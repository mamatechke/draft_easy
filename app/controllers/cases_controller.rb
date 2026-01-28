class CasesController < ApplicationController
  before_action :require_login
  before_action :set_case, only: [:show, :download_pdf, :destroy, :summarize, :download_summary]
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

  # DELETE /cases/:id
  def destroy
    @case.destroy
    redirect_to cases_path, notice: "Case deleted."
  end

  def new
    @case = Current.user.cases.new
  end

  def create
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
    @case = Current.user.cases.find(params[:id])
  end

  def case_params
    params.require(:case).permit(
      :case_name, :citation, :court, :jurisdiction, :decision_year,
      :procedural_history, :facts, :legal_issue, :holding, :rule_of_law,
      :reasoning, :conclusion, :concurring_opinions, :dissenting_opinions,
      :document
    )
  end

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
