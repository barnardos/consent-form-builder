module ResearchSessions
  class QuestionsController < ApplicationController
    include Wicked::Wizard
    steps(*ResearchSession::Steps::PARAMS.keys)

    rescue_from Wicked::Wizard::InvalidStepError do
      render status: 404,
             plain: %(Step "#{params[:id]}" not found)
    end

    def show
      @research_session = current_research_session
      render_wizard
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

    def current_research_session
      ResearchSession.find_by(slug: params[:research_session_id])
    end

    def returning_to_preview?
      params['edit-preview'] == '1'
    end

    def question_params
      params.require(:research_session).permit(ResearchSession::Steps::PARAMS[step]).tap do |p|
        p['methodologies']&.reject!(&:blank?)
        p['recording_methods']&.reject!(&:blank?)
      end
    end
  end
end
