class SharedWith
  NAME_VALUES = HashWithIndifferentAccess.new(
    anonymised: 'All identifiable information will be anonymised as we process it',
    team:       'Identifiable information will only be shared with the research team at Barnardo\'s',
    internal:   'Identifiable information will be shared with other teams in Barnardo\'s',
    external:   'Identifiable information will be used in external publications'
  )

  def self.allowed_values
    NAME_VALUES.keys
  end
end
