class ResearchSessionsController < ApplicationController
  helper Barnardos::ActionView::FormHelper

  include Wicked::Wizard
  steps *ResearchSession::Steps::PARAMS.keys

  rescue_from Wicked::Wizard::InvalidStepError do
    render status: 404,
           plain: %(Step "#{params[:id]}" not found)
  end

  def new
    @research_session = ResearchSession.new
  end

  def create
    @research_session = ResearchSession.new(session_creation_params)
    if @research_session.save
      redirect_to(first_question_path(@research_session.id))
    else
      render :new
    end
  end

  def show
    @research_session = current_research_session
    render_wizard
  end

  def preview
    @research_session = current_research_session

    # Allow the user to pass a parameter to switch between over 18 and under 18 mode
    able_to_consent = params['able-to-consent'] == 'yes' ? true : false

    @research_session = ResearchSessionPresenter.new(
      @research_session,
      able_to_consent: able_to_consent
    )
  end

  def update
    @research_session = current_research_session
    @research_session.status = step unless @research_session.reached_step?(step)
    @research_session.assign_attributes(question_params)
    if returning_to_preview? && @research_session.save
      redirect_to(research_session_preview_path, research_session_id: @research_session.id)
    else
      render_wizard @research_session
    end
  end

  def finish_wizard_path
    research_session_preview_path
  end

private
  def session_creation_params
    params.require(:research_session).permit(:name)
  end

  def returning_to_preview?
    params['edit-preview'] == '1'
  end

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

