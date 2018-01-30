class ResearchSessionsController < ApplicationController
  def new
    @research_session = ResearchSession.new
    return unless params[:from_existing].present?

    existing_session = ResearchSession.find_by!(slug: params[:from_existing])
    @existing_session_id = existing_session.slug
    proposed_new_name = "#{existing_session.name} (copy)"
    @research_session.name = proposed_new_name
    render 'create_a_copy'
  end

  def create
    @research_session = ResearchSession.new(session_creation_params)
    if @research_session.save
      redirect_to(first_question_path)
    else
      render :new
    end
  end

  def create_a_copy
    @research_session = ResearchSession.find_by!(slug: params[:research_session_id])

    plain_400 && return unless @research_session.previewable?

    @research_session.dup.tap do |new_research_session|
      new_research_session.assign_attributes(session_creation_params)
      new_research_session.set_slug_from_name!
      new_research_session.save!
      redirect_to(research_session_preview_path(new_research_session))
    end
  end

  def preview
    @research_session = current_research_session

    # Allow the user to pass a parameter to switch between over 18 and under 18 mode
    able_to_consent = params['able-to-consent'] == 'yes'

    @research_session = ResearchSessionPresenter.new(
      @research_session,
      able_to_consent: able_to_consent
    )
  end

private
  def research_session_slug
    params[:research_session_id] || params[:id]
  end

  def session_creation_params
    params.require(:research_session).permit(:name)
  end

  def current_research_session
    ResearchSession.find_by!(slug: research_session_slug)
  end

  def first_question_path
    research_session_question_path(@research_session, id: ResearchSession::Steps.instance.first)
  end

  def plain_400
    render status: 400,
           plain: %(Research Session "#{research_session_slug}" can't have a copy yet)
  end
end
