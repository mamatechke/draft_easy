class CasesController < ApplicationController
  before_action :require_login
  before_action :set_case, only: [:show]

  def new
    @case = Current.user.cases.new
  end

  def create
    @case = Current.user.cases.new(case_params)
    if @case.save
      redirect_to @case, notice: "Case created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @cases = Current.user.cases.order(created_at: :desc)
  end

  def show
  end

  private

  def set_case
    @case = Current.user.cases.find(params[:id])
  end

  def case_params
    params.require(:case).permit(:case_name, :citation, :court, :jurisdiction, :decision_year, :procedural_history, :facts, :legal_issue, :holding, :rule_of_law, :reasoning, :conclusion, :concurring_opinions, :dissenting_opinions)
  end

  def require_login
    redirect_to sign_in_path unless Current.user
  end
end
