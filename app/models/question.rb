class Question
  ORDERED_KEYS = [:age, :name, :methods, :recording, :focus, :researcher, :incentive]
  PARAM_KEYS = [:age, :participant_name, :guardian_name]

  def self.first
    ORDERED_KEYS.first
  end

  def self.next(current)
    current_index = ORDERED_KEYS.index(current.to_sym)
    return nil if current_index.nil?
    ORDERED_KEYS[current_index.next]
  end
end