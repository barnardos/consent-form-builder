class ResearchSessionPresenter < Struct.new(:research_session)
  include ActionView::Helpers::NumberHelper

  ResearchSession.attribute_names.each do |attribute|
    delegate attribute, to: :research_session
  end

  delegate :unable_to_consent?, :able_to_consent?, :reached_step?,
           to: :research_session

  [:researcher_name, :researcher_email, :researcher_phone].each do |attr|
    define_method(attr) do
      research_session.researchers.first.send attr
    end
  end

  def methodology_list
    paras = research_session.methodologies.map do |methodology|
      translation = if methodology.to_s == 'other'
                      other_methodology
                    else
                      I18n.t("report.#{age}.#{methodology}")
                    end
      "<p class='highlight'>#{translation}</p>"
    end
    paras.join("\n").html_safe
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
    return '' unless research_session.incentive

    formatted_value = number_to_currency(research_session.incentive_value, locale: 'en')

    if research_session.payment_type == 'cash'
      "a cash incentive of #{formatted_value}"
    elsif research_session.payment_type == 'voucher'
      "high street vouchers to the value of #{formatted_value}"
    end
  end
end
