class RecordingMethods
  NAME_VALUES = {
    voice:    'voice recording',
    video:    'video recording',
    written:  'written notes',
    workshop: 'the work created by participants during the session',
    photo:    'photos',
    screen:   'a video of your screen as the participant uses the tool',
    other:    'other'
  }

  def self.allowed_values
    NAME_VALUES.keys
  end
end
