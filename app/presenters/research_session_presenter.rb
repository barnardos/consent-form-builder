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

  def any_expenses?
    !!(
      travel_expenses_limit&.nonzero? ||
        food_expenses_limit&.nonzero? ||
        other_expenses_limit&.nonzero?
    )
  end
end
