class RecordingMethods
  NAME_VALUES = {
    audio:    'Audio',
    video:    'Video',
    written:  'Written notes',
    workshop: 'Workshop outputs',
    photo:    'Photographs',
    user:     'User generated content',
    screen:   'Screen recording',
    other:    'Other'
  }

  def self.allowed_values
    NAME_VALUES.keys
  end
end
