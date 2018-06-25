class RecordingMethods
  CHOICES = [
    {
      id: 'voice',
      value: 'voice',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.voice')
    },
    {
      id: 'video',
      value: 'video',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.video')
    },
    {
      id: 'written',
      value: 'written',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.written')
    },
    {
      id: 'workshop',
      value: 'workshop',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.workshop')
    },
    {
      id: 'photo',
      value: 'photo',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.photo')
    },
    {
      id: 'screen',
      value: 'screen',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.screen')
    },
    {
      id: 'other',
      value: 'other',
      label: I18n.t('preview.able_to_consent.the_research.recording_methods.other')
    }
  ].freeze

  def self.allowed_values
    CHOICES.map { |choice| choice[:value].to_sym }
  end
end
