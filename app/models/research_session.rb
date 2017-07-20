class ResearchSession < ApplicationRecord
  STEP_PARAMS = ActiveSupport::OrderedHash[{
    age:           [:age],
    name:          [:participant_name, :guardian_name],
    methodologies: [:methodologies],
    recording:     [:recording_methods],
    focus:         [:focus],
    researcher:    [:researcher_name, :researcher_phone, :researcher_email, :researcher_other_name],
    incentive:     [:incentive, :payment_type, :incentive_value]
  }]

  validates :age, inclusion: { in: Age.allowed_values }
  validates :methodologies,
            has_at_least_one: { of: Methodologies.allowed_values },
            if: -> (session) { session.has_reached_step?(:methodologies) }
  validates :recording_methods,
            has_at_least_one: { of: RecordingMethods.allowed_values },
            if: -> (session) { session.has_reached_step?(:recording) }
  validates :focus, presence: true,
            if: -> (session) { session.has_reached_step?(:focus) }
  validates :researcher_name, presence: true,
            if: -> (session) { session.has_reached_step?(:researcher) }
  validates :researcher_phone, presence: true,
            if: -> (session) { session.has_reached_step?(:researcher) }
  validates :researcher_email, presence: true,
            if: -> (session) { session.has_reached_step?(:researcher) }
  validates :researcher_email, format: /@/,
    if: -> (session) { session.researcher_email.present? && session.has_reached_step?(:researcher) }

  def has_reached_step?(step)
    step = step.to_sym
    return false if status == 'new'
    step_indices.fetch(status.to_sym) >= step_indices.fetch(step)
  end

private
  def step_keys
    @@step_keys ||= STEP_PARAMS.keys
  end

  ##
  # A hash of step names as symbols to numeric indices, with age: 0, name: 1 etc
  def step_indices
    @@step_indices ||= step_keys.each_with_index.map {|step, index| [step, index]}.to_h
  end
end
