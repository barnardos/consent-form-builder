class Methodologies
  NAME_VALUES = {
    interview:   'a one-on-one interview',
    usability:   'an observation of trying out (the new tool) we’re designing',
    survey:      'a survey or paper questionnaire',
    focusgroup:  'a group discussion',
    codesign:    'a group activity',
    other:       'Other'
  }

  def self.allowed_values
    NAME_VALUES.keys
  end
end
