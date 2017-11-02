class ResearchSessionsController < ApplicationController
  def new
    @research_session = ResearchSession.new
  end

  def create
    @research_session = ResearchSession.new(session_creation_params)
    if @research_session.save
      redirect_to(first_question_path)
    else
      render :new
    end
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

private
  def session_creation_params
    params.require(:research_session).permit(:name)
  end

  def current_research_session
    ResearchSession.find_by(slug: params[:research_session_id])
  end

  def first_question_path
    research_session_question_path(
      @research_session,
      id: ResearchSession::Steps.instance.first
    )
  end
end

