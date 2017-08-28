class ResearchSession < ApplicationRecord
  validates :methodologies,
            has_at_least_one: { of: Methodologies.allowed_values },
            if: -> (session) { session.reached_step?(:methodologies) }
  validates :other_methodology, presence: true,
            if: lambda { |session|
              session.reached_step?(:methodologies) &&
                session.methodologies&.any? { |item| item.to_s == 'other' }
            }
  validates :other_recording_method, presence: true,
            if: lambda { |session|
              session.reached_step?(:recording) &&
                session.recording_methods&.any? { |item| item.to_s == 'other' }
            }
  validates :recording_methods,
            has_at_least_one: { of: RecordingMethods.allowed_values },
            if: -> (session) { session.reached_step?(:recording) }
  validates :topic, presence: true,
            if: -> (session) { session.reached_step?(:topic) }
  validates :purpose, presence: true,
            if: -> (session) { session.reached_step?(:purpose) }
  validates :researcher_name, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_phone, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_email, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_email, format: /@/,
    if: -> (session) { session.researcher_email.present? && session.reached_step?(:researcher) }

  validates :shared_with, inclusion: { in: SharedWith.allowed_values },
            if: -> (session) { session.reached_step?(:data) }

  validates :shared_duration, presence: true,
            if: -> (session) { session.reached_step?(:data) }

  validates :shared_use, presence: true,
            if: -> (session) { session.reached_step?(:data) }

  validates :payment_type, inclusion: { in: PaymentType.allowed_values },
    if: -> (session) { session.incentive && session.reached_step?(:incentive) }
  validates :incentive_value, presence: true,
    if: -> (session) { session.incentive && session.reached_step?(:incentive) }

  def able_to_consent?
    age == 'over18'
  end

  def unable_to_consent?
    !able_to_consent?
  end

  def reached_step?(step)
    Steps.instance.reached_step?(self, step)
  end
end
