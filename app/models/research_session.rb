require 'securerandom'

class ResearchSession < ApplicationRecord
  before_create :set_slug_from_name!

  validates :name, presence: true

  validates :researcher_name, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_email, presence: true,
            if: -> (session) { session.reached_step?(:researcher) }
  validates :researcher_email, format: /\A\S+@\S+\Z/,
    if: -> (session) { session.researcher_email.present? && session.reached_step?(:researcher) }

  validates :topic, presence: true,
    if: -> (session) { session.reached_step?(:topic) }
  validates :purpose, presence: true,
    if: -> (session) { session.reached_step?(:topic) }

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

  validates :shared_with, inclusion: { in: SharedWith.allowed_values },
            if: -> (session) { session.reached_step?(:storing) }

  validates :shared_duration, presence: true,
            if: -> (session) { session.reached_step?(:storing) }

  validates :travel_expenses_limit, numericality: true,
            if: -> (session) { session.expenses_validation(:travel_expenses_limit) }
  validates :food_expenses_limit, numericality: true,
            if: -> (session) { session.expenses_validation(:food_expenses_limit) }
  validates :other_expenses_limit, numericality: true,
            if: -> (session) { session.expenses_validation(:other_expenses_limit) }

  validates :payment_type, inclusion: { in: PaymentType.allowed_values },
            if: -> (session) { session.incentives_enabled && session.reached_step?(:incentives) }
  validates :incentive_value, presence: true, numericality: true,
            if: -> (session) { session.incentives_enabled && session.reached_step?(:incentives) }

  def previewable?
    status == Steps.instance.last.to_s
  end

  def reached_step?(step)
    Steps.instance.reached_step?(self, step)
  end

  def set_slug_from_name!
    return if name.blank?

    slug = name.strip.downcase.tr(' ', '-')
    slug = "#{slug}-#{SecureRandom.uuid}" if ResearchSession.exists?(slug: slug)
    self.slug = slug
  end

  def to_param
    slug
  end

  def expenses_validation(category)
    other_expenses_used = Expenses::CATEGORIES
                          .reject { |expense| expense == category }
                          .all? { |expense| send(expense).blank? }
    send(category).present? || (expenses_enabled && reached_step?(:expenses) && other_expenses_used)
  end
end
