module ResearchSessionsHelper
  ##
  # Assemble Rails-y research session params for a React component that
  # can't be gleaned client side. Attribute values and an editLinks
  # hash, e.g. component_params :researcher_name, final_preview: true
  #  {
  #    researcher_name: 'Rachel',
  #    editLinks: {
  #      researcher_name: '/research-sessions/name/questions/researcher'
  #    }
  #  }
  def component_params(*attrs, final_preview: false)
    attrs.each_with_object(
      editLinks: {}, finalPreview: final_preview
    ) do |attr, result|
      result[attr] = @research_session.send(attr)

      next unless final_preview

      step = ResearchSession::Steps.instance.attr_to_step(attr)
      result[:editLinks][attr] =
        research_session_question_path(
          research_session_id: @research_session.slug, id: step, 'edit-preview': 1
        )
    end
  end

  def edit_link_for(attr, &block)
    value = block_given? ? capture(&block) : @research_session.send(attr)

    step_for_attr = ResearchSession::Steps.instance.attr_to_step(attr)

    link_to value,
            research_session_question_path(
              @research_session.slug, step_for_attr, 'edit-preview' => '1'
            ),
            class: 'editable'
  end

  def methodology_lookup(methodology)
    consent_translation_key =
      @research_session.able_to_consent? ? 'able_to_consent' : 'unable_to_consent'
    if methodology.to_s == 'other'
      @research_session.other_methodology
    else
      I18n.t("report.#{consent_translation_key}.#{methodology}")
    end
  end

  def shared_with_lookup(shared_with)
    I18n.t("preview.shared_with.#{shared_with}", person: you_or_your_child)
  end

  def you_or_your_child
    @research_session.able_to_consent? ? 'you' : 'your child/the child in your care'
  end

  def you_or_they
    @research_session.able_to_consent? ? 'you' : 'they'
  end
end
