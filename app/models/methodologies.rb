class Methodologies
  CHOICES = [
    {
      id: 'interview',
      value: 'interview',
      label: I18n.t('preview.able_to_consent.what_happens_in_this_research_session.methodologies.interview')
    },
    {
      id: 'usability',
      value: 'usability',
      label: I18n.t('preview.able_to_consent.what_happens_in_this_research_session.methodologies.usability')
    },
    {
      id: 'survey',
      value: 'survey',
      label: I18n.t('preview.able_to_consent.what_happens_in_this_research_session.methodologies.survey')
    },
    {
      id: 'focusgroup',
      value: 'focusgroup',
      label: I18n.t('preview.able_to_consent.what_happens_in_this_research_session.methodologies.focusgroup')
    },
    {
      id: 'codesign',
      value: 'codesign',
      label: I18n.t('preview.able_to_consent.what_happens_in_this_research_session.methodologies.codesign')
    },
    {
      id: 'other',
      value: 'other',
      label: I18n.t('preview.able_to_consent.what_happens_in_this_research_session.methodologies.other')
    }
  ].freeze

  def self.allowed_values
    CHOICES.map { |choice| choice[:value].to_sym }
  end
end
