class SharedWith
  CHOICES = [
    {
      id: 'anonymised',
      value: 'anonymised',
      label: 'It won’t be'
    },
    {
      id: 'team',
      value: 'team',
      label: 'within the research team'
    },
    {
      id: 'internal',
      value: 'internal',
      label: 'within Barnardo’s'
    },
    {
      id: 'external',
      value: 'external',
      label: 'publicly'
    }
  ].freeze

  def self.allowed_values
    CHOICES.map { |choice| choice[:value] }
  end
end
