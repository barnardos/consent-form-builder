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

  def able_to_consent?
    @able_to_consent
  end

  def unable_to_consent?
    !@able_to_consent
  end

  def recording_methods_list
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

  def expenses_sentence
    return nil unless any_expenses?
    fragments = [
      :travel_expenses,
      :food_expenses,
      :other_expenses
    ].map do |expense_attr|
      value = send("#{expense_attr}_limit")
      if value&.nonzero?
        "#{expense_attr.to_s.humanize.downcase} of up to "\
        "#{number_to_currency(value, locale: 'en')}"
      end
    end
    "We allow #{fragments.compact.to_sentence}."
  end

  def incentive_text
    return '' unless research_session.incentives_enabled

    formatted_value = number_to_currency(research_session.incentive_value, locale: 'en')

    if research_session.payment_type == 'cash'
      "a cash incentive of #{formatted_value}"
    elsif research_session.payment_type == 'voucher'
      "high street vouchers to the value of #{formatted_value}"
    end
  end
end
