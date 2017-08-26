class SharedWith
  NAME_VALUES = HashWithIndifferentAccess.new(
    team:     'Just the team',
    internal: 'Other teams internally',
    externa:  'Other teams externally'
  )

  def self.allowed_values
    NAME_VALUES.keys
  end
end
