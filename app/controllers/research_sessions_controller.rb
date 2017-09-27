class ResearchSessionsController < ApplicationController
  helper Barnardos::ActionView::FormHelper

  include Wicked::Wizard
  steps *ResearchSession::Steps::PARAMS.keys

  rescue_from Wicked::Wizard::InvalidStepError do
    render status: 404,
           plain: %(Step "#{params[:id]}" not found)
  end

  def index
    @research_session = ResearchSession.new
  end

  def create
    session = ResearchSession.create
    redirect_to(first_question_path(session.id))
  end

  def show
    @research_session = current_research_session
    if (step == :researcher) && @research_session.researchers.none?
      @research_session.researchers.build
    end
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
    @research_session.save
    render_wizard @research_session
  end

  def finish_wizard_path
    research_session_preview_path
  end

private
  def current_research_session
    ResearchSession.find(params[:research_session_id])
  end

  def first_question_path(id)
    research_session_question_path(research_session_id: id, id: steps.first)
  end

  def question_params
    params.require(:research_session).permit(ResearchSession::Steps::PARAMS[step]).tap do |p|
      p['methodologies']&.reject!(&:blank?)
      p['recording_methods']&.reject!(&:blank?)
    end
  end
end

