class Age
  NAME_VALUES = HashWithIndifferentAccess.new({
    under12: 'Under 12 years old',
    '12to18' => '12 to 18 years old',
    over18dr: 'Over 18 years old but unable to sufficiently understand the consent process',
    over18: 'Over 18 years old',
  })

  def self.allowed_values
    NAME_VALUES.keys
  end
end
