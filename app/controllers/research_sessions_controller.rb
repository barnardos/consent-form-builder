class ResearchSessionsController < ApplicationController
  helper Barnardos::ActionView::FormHelpers

  include Wicked::Wizard
  steps *ResearchSession::STEP_PARAMS.keys

  rescue_from Wicked::Wizard::InvalidStepError do
    render status: 404,
           plain: %(Step "#{params[:id]}" not found)
  end

  def index
  end

  def start
    redirect_to(first_question_path)
  end

  def show
    @session_data = session_data
    render_wizard
  end

  def update
    session_data.merge!(question_params)
    redirect_to(question_path(id: next_step))
  end

private
  def session_data
    session[:data] ||= {}
  end

  def first_question_path
    question_path(id: steps.first)
  end

  def question_params
    params.permit(ResearchSession::STEP_PARAMS[step])
  end
end

