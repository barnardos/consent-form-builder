# frozen_string_literal: true

class ResearchSessionPresenter
  include ActionView::Helpers::NumberHelper

  attr_accessor :research_session
  def initialize(research_session, able_to_consent: false)
    self.research_session = research_session
    @able_to_consent = able_to_consent
  end

  delegate :to_param, to: :research_session

  def respond_to_missing?(method, *)
    research_session.respond_to?(method)
  end

  def method_missing(*args, &block)
    research_session.send(*args, &block)
  rescue NoMethodError
    super
  end

  def able_to_consent_key
    able_to_consent? ? 'able_to_consent' : 'unable_to_consent'
  end

  def able_to_consent?
    @able_to_consent
  end

  def unable_to_consent?
    !@able_to_consent
  end

  def recording_methods_sentence
    lowercase_words = research_session.recording_methods.map do |method|
      if method.to_s == 'other'
        other_recording_method
      else
        RecordingMethods::NAME_VALUES.fetch(method.to_sym).downcase
      end
    end
    lowercase_words.to_sentence
  end

  def any_expenses?
    !!(
      travel_expenses_limit&.nonzero? ||
        food_expenses_limit&.nonzero? ||
        other_expenses_limit&.nonzero?
    )
  end
end
