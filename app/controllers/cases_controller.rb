class CasesController < ApplicationController
  before_action :require_login
  before_action :set_case, only: [:show, :download_pdf, :destroy, :summarize, :download_summary, :search_precedents, :generate_draft, :export_word]
  # POST /cases/:id/summarize
  def summarize
    if @case.extracted_text.present?
      summary = OllamaSummarizer.summarize(@case.extracted_text)
      @case.update(summary: summary)
      flash[:notice] = "Summary generated successfully."
    else
      flash[:alert] = "No extracted text available to summarize."
    end
    redirect_to @case
  end

  # GET /cases/:id/download_summary
  def download_summary
    if @case.summary.present?
      send_data @case.summary, filename: "case_#{@case.id}_summary.txt", type: "text/plain", disposition: "attachment"
    else
      redirect_to @case, alert: "No summary available to download."
    end
  end

  # POST /cases/:id/search_precedents
  def search_precedents
    unless Current.user.can_search_precedents?
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("precedents-section", partial: "cases/precedents", locals: { precedents: [], query: "", error: "You have reached your precedent search limit. Please upgrade your plan." }) }
        format.html { redirect_to @case, alert: "You have reached your precedent search limit. Please upgrade your plan." }
      end
      return
    end

    query = params[:query].presence || ""
    @precedents = PrecedentSearcher.search(query)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("precedents-section", partial: "cases/precedents", locals: { precedents: @precedents, query: query }) }
      format.html { redirect_to @case }
    end
  end

  # POST /cases/:id/generate_draft
  def generate_draft
    style = params[:draft_style] || "formal"
    precedents_text = params[:selected_precedents].presence || "No specific precedents selected."

    prompt = case style
             when "concise"
               "Generate a concise legal draft based on the following summary and precedents."
             when "formal"
               "Generate a formal legal judgment draft based on the following summary and precedents."
             else
               "Generate a standard legal draft based on the following summary and precedents."
             end

    full_prompt = "#{prompt}\n\nSummary: #{@case.summary}\n\nPrecedents: #{precedents_text}\n\nCase Details: #{@case.facts}"

    draft = OllamaSummarizer.summarize(full_prompt) # Reuse for draft gen
    @case.update(draft_content: draft, draft_style: style)
    redirect_to @case, notice: "Draft generated successfully."
  rescue => e
    redirect_to @case, alert: "Failed to generate draft: #{e.message}"
  end

  # GET /cases/:id/export_word
  def export_word
    if @case.draft_content.present?
      Caracal::Document.save "case_#{@case.id}_draft.docx" do |docx|
        docx.h1 "Case Draft: #{@case.case_name}"
        docx.p "Style: #{@case.draft_style&.titleize}"
        docx.p @case.draft_content.to_plain_text
      end
      send_file "case_#{@case.id}_draft.docx", filename: "case_#{@case.id}_draft.docx", type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", disposition: "attachment"
    else
      redirect_to @case, alert: "No draft available to export."
    end
  end

  # DELETE /cases/:id
  def destroy
    @case.destroy
    redirect_to cases_path, notice: "Case deleted."
  end

  def new
    @case = Current.user.cases.new
  end

  def create
    unless Current.user.can_create_case?
      redirect_to cases_path, alert: "You have reached your case limit. Please upgrade your plan." and return
    end

    @case = Current.user.cases.new(case_params)

    # Save case and attached file
    if @case.save
      # If PDF attached, extract and autofill fields, then redirect to edit for review
      if @case.document.attached? && @case.document.content_type == "application/pdf"
        text = CaseTextExtractor.extract(@case.document)
        autofill = CasePdfAutoFiller.extract_fields(text)
        @case.update(autofill.merge(extracted_text: text))
        flash[:notice] = "Fields were auto-filled from your PDF. Please review and complete any missing information."
        redirect_to edit_case_path(@case) and return
      end
      if @case.deadline.present?
        ReminderJob.set(wait_until: @case.deadline - 7.days).perform_later(@case.id)
      end
      redirect_to @case, notice: "Case created successfully."
    else
      flash.now[:alert] = @case.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @case = Current.user.cases.find(params[:id])
  end

  def update
    @case = Current.user.cases.find(params[:id])
    if @case.update(case_params)
      if @case.deadline.present? && @case.deadline_changed?
        ReminderJob.set(wait_until: @case.deadline - 7.days).perform_later(@case.id)
      end
      redirect_to @case, notice: "Case updated successfully."
    else
      flash.now[:alert] = @case.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @cases = Current.user.cases.order(created_at: :desc)
  end

  def show
  end

  def download_pdf
    pdf = CasePdf.new(@case)
    send_data pdf.render, filename: "case_#{@case.id}.pdf", type: "application/pdf", disposition: "attachment"
  end

  private

  def set_case
    @case = Current.user.cases.find_by(id: params[:id])
    unless @case
      redirect_to cases_path, alert: "Case not found or access denied"
    end
  end

  def case_params
    params.require(:case).permit(
      :case_name, :citation, :court, :jurisdiction, :decision_year,
      :procedural_history, :facts, :legal_issue, :holding, :rule_of_law,
      :reasoning, :conclusion, :concurring_opinions, :dissenting_opinions,
      :document, :parties, :case_type, :draft_style, :deadline,
      draft_content: {}
    )
  end

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
