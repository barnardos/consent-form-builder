class SharedWith
  CHOICES = [
    {
      id: 'anonymised',
      value: 'anonymised',
      label: 'Anonymised as we process it'
    },
    {
      id: 'team',
      value: 'team',
      label: 'Shared with the research team at Barnardoʼs'
    },
    {
      id: 'internal',
      value: 'internal',
      label: 'Shared with other teams in Barnardoʼs'
    },
    {
      id: 'external',
      value: 'external',
      label: 'Used in external publications'
    }
  ].freeze

  def self.allowed_values
    CHOICES.map { |choice| choice[:value] }
  end
end
