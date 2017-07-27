class ResearchSessionPresenter < Struct.new(:research_session)
  delegate :age, :focus, :researcher_name, :researcher_other_name,
           :researcher_email, :researcher_phone, :unable_to_consent?,
           to: :research_session

  def methodology_list
    paras = research_session.methodologies.map do |methodology|
      i18n_key = "age.#{age}.#{methodology}"
      "<p class='highlight'>#{I18n.t(i18n_key)}</p>"
    end
    paras.join("\n").html_safe
  end

  def recording_methods_list
    lowercase_words = research_session.recording_methods.map do |method|
      RecordingMethods::NAME_VALUES.fetch(method.to_sym).downcase
    end
    lowercase_words.to_sentence
  end
end
