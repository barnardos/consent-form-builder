# frozen_string_literal: true

class Methodologies
  NAME_VALUES = {
    interview:   'a one-on-one interview',
    usability:   'looking at how you use a new tool we’re designing',
    survey:      'a survey or paper questionnaire',
    focusgroup:  'a group discussion',
    codesign:    'a group activity',
    other:       'Other'
  }.freeze

  def self.allowed_values
    NAME_VALUES.keys
  end
end
