# frozen_string_literal: true

class SharedWith
  NAME_VALUES = HashWithIndifferentAccess.new(
    anonymised: 'anonymised as we process it',
    team:       'shared with the research team at Barnardoʼs',
    internal:   'shared with other teams in Barnardoʼs',
    external:   'used in external publications'
  )

  def self.allowed_values
    NAME_VALUES.keys
  end
end
