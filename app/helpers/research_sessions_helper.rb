module ResearchSessionsHelper
  def edit_link_for(attr, &block)
    value = block_given? ? capture(&block) : @research_session.send(attr)

    step_for_attr = ResearchSession::Steps.instance.attr_to_step(attr)

    link_to value, question_path(step_for_attr), class: 'editable'
  end
end
