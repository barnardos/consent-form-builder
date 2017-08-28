class ResearchSessionsController < ApplicationController
  helper Barnardos::ActionView::FormHelpers

  include Wicked::Wizard
  steps *ResearchSession::Steps::PARAMS.keys

  rescue_from Wicked::Wizard::InvalidStepError do
    render status: 404,
           plain: %(Step "#{params[:id]}" not found)
  end

  def index
  end

  def start
    session[:current_research_session_id] = nil
    redirect_to(first_question_path)
  end

  def show
    @research_session = current_research_session
    render_wizard
  end

  def preview
    @research_session = current_research_session

    # Allow the user to pass a parameter to switch between over 18 and under 18 mode
    if params.key?('age')
      @research_session.assign_attributes(params.permit(:age))
    end

    @research_session = ResearchSessionPresenter.new(@research_session)
  end

  def update
    @research_session = current_research_session
    @research_session.status = step
    @research_session.assign_attributes(question_params)
    render_wizard @research_session
  end

  def finish_wizard_path
    research_session_preview_path
  end

private
  def current_research_session
    id = session[:current_research_session_id]
    research_session = ResearchSession.find(id) if id.present?
    research_session ||= ResearchSession.create
    session[:current_research_session_id] = research_session.id
    research_session
  end

  def first_question_path
    question_path(id: steps.first)
  end

  def question_params
    params.permit(ResearchSession::Steps::PARAMS[step])
  end
end

