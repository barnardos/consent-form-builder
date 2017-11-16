class SharedWith
  NAME_VALUES = HashWithIndifferentAccess.new(
    anonymised: 'anonymised as we process it',
    team:       'shared with the research team at Barnardo\'s',
    internal:   'shared with other teams in Barnardo\'s',
    external:   'used in external publications'
  )

  def self.allowed_values
    NAME_VALUES.keys
  end
end
