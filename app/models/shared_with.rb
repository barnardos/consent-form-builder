class SharedWith
  NAME_VALUES = HashWithIndifferentAccess.new(
    anonymised: I18n.t('helpers.label.storing_information.shared_with.anonymised'),
    team:       I18n.t('helpers.label.storing_information.shared_with.team'),
    internal:   I18n.t('helpers.label.storing_information.shared_with.internal'),
    external:   I18n.t('helpers.label.storing_information.shared_with.external')
  )

  def self.allowed_values
    NAME_VALUES.keys
  end
end
