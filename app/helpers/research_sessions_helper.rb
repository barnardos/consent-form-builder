# frozen_string_literal: true

module ResearchSessionsHelper
  def edit_link_for(attr)
    step_for_attr = ResearchSession::Steps.instance.attr_to_step(attr)

    research_session_question_path(
      @research_session.slug, step_for_attr, 'edit-preview' => '1'
    )
  end

  def able_to_consent?
    @research_session.respond_to?(:able_to_consent?) ? @research_session.able_to_consent? : false
  end
end
