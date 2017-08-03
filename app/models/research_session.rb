class ResearchSession < ApplicationRecord
  validates :age, inclusion: { in: Age.allowed_values },
            if: -> (session) { session.reached_step?(:age) }
  validates :methodologies,
            has_at_least_one: { of: Methodologies.allowed_values },
            if: -> (session) { session.reached_step?(:methodologies) }
  validates :recording_methods,
            has_at_least_one: { of: RecordingMethods.allowed_values },
            if: -> (session) { session.reached_step?(:recording) }
  validates :focus, presence: true,
            if: -> (session) { session.reached_step?(:focus) }
  validates :researcher_name, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_phone, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_email, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_email, format: /@/,
    if: -> (session) { session.researcher_email.present? && session.reached_step?(:researcher) }
  validates :payment_type, inclusion: { in: PaymentType.allowed_values },
    if: -> (session) { session.incentive && session.reached_step?(:incentive) }
  validates :incentive_value, presence: true,
    if: -> (session) { session.incentive && session.reached_step?(:incentive) }

  def able_to_consent?
    age.to_sym == :over18
  end

  def unable_to_consent?
    !able_to_consent?
  end

  def reached_step?(step)
    Steps.instance.reached_step?(self, step)
  end
end
