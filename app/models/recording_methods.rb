# frozen_string_literal: true

class RecordingMethods
  NAME_VALUES = {
    voice:    'voice recording',
    video:    'video recording',
    written:  'researcher’s written notes',
    workshop: 'the work created by participants during the session',
    photo:    'photos',
    screen:   'screen recording',
    other:    'other'
  }.freeze

  def self.allowed_values
    NAME_VALUES.keys
  end
end
