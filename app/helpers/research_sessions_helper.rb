module ResearchSessionsHelper
  def current_step_params
    component_params(*flat_params(step))
      .merge(unvarying_params(step))
      .merge(able_to_consent: false)
  end

  def final_preview_params(step)
    component_params(*flat_params(step), final_preview: true)
      .merge(unvarying_params(step))
      .merge(able_to_consent: @research_session.able_to_consent?)
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
    if methodology.to_s == 'other'
      @research_session.other_methodology
    else
      Methodologies::NAME_VALUES[methodology.to_sym]
    end
  end

  def shared_with_lookup(shared_with)
    I18n.t("preview.shared_with.#{shared_with}", person: you_or_your_child)
  end

  ##
  # On final preview the research session has a presenter that can
  # respond to able_to_consent?. In live previews this is not the case
  # and we need to default to no consent.
  #
  def able_to_consent?
    @research_session.respond_to?(:able_to_consent?) ? @research_session.able_to_consent? : false
  end

  def you_or_your_child
    able_to_consent? ? 'you' : 'your child/the child in your care'
  end

  def your_or_your_childs
    able_to_consent? ? 'your' : "your child's/the child in your care's"
  end

  def you_or_they
    able_to_consent? ? 'you' : 'they'
  end

  def your_or_their
    able_to_consent? ? 'your' : 'their'
  end

  def i_or_they
    able_to_consent? ? 'I' : 'they'
  end

  def say_or_says
    able_to_consent? ? 'say' : 'says'
  end

private

  def flat_params(step)
    ResearchSession::Steps::PARAMS[step].flat_map do |param|
      param.is_a?(Hash) ? param.keys : param
    end
  end

  ##
  # For any given step, provide params that would not vary called
  # from live preview/final preview to avoid duplication
  def unvarying_params(step)
    unvarying_params = {
      topic: {
        labels: {
          topic: I18n.t('research_session_attr_labels.topic'),
          purpose: I18n.t('research_session_attr_labels.purpose')
        }
      },
      storing: {
        shared_with_sentences:
          SharedWith::NAME_VALUES.keys.each_with_object({}) do |attr, result|
            result[attr.to_sym] = I18n.t("preview.shared_with.#{attr}", person: you_or_your_child)
          end
      },
      recording: {
        all_recording_methods: RecordingMethods::NAME_VALUES
      },
      methodologies: {
        all_methodologies: Methodologies::NAME_VALUES
      }
    }
    unvarying_params[step] || {}
  end

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
end
