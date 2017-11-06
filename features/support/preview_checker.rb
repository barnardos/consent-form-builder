##
# Check the content for the happy path where everything is
# filled in
#
module PreviewChecker
  def check_researcher
    expect(page.body).to include('Rachel Researcher')
    expect(page.body).to include('012345678')
    expect(page.body).to include('rachel@researcher.com')
  end

  def check_topic
    @topic.split("\n").each do |line|
      expect(page.body).to include(line)
    end
    @purpose.split("\n").each do |line|
      expect(page.body).to include(line)
    end
  end

  def check_methodologies
    @methodologies.each do |methodology_display_name|
      methodology = Methodologies::NAME_VALUES.key(methodology_display_name)
      expect(page.body).to have_tag(
        'a.editable',
        text: Regexp.new(I18n.t("report.unable_to_consent.#{methodology}"))
      )
    end
  end

  def check_recording
    @recording_methods.each do |recording_method|
      expect(page.body).to include(recording_method.downcase)
    end
  end

  def check_storing
    expect(page.body).to have_tag(
      'a.editable',
      text: Regexp.new(
        I18n.t(
          'report.shared_with.anonymised',
          person: 'your child/the child in your care'
        )
      )
    )
    expect(page.body).to have_tag(
      'p',
      text: Regexp.new(
        "All data will be deleted after #{@shared_duration}."
      )
    )
  end

  def check_where_when
    expect(page.body).to include('The session is on')
    expect(page).to have_tag('a.editable', text: @session_duration)
    expect(page).to have_tag('a.editable', text: @session_location)
    expect(page).to have_tag('a.editable', text: @held_on)
    expect(page).to have_tag('a.editable', text: @what_to_bring)
  end

  def check_expenses
    expect(page.body).to include(
      'We allow travel expenses of up to £50.00, food expenses of up to £20.00, '\
      'and other expenses of up to £10.00.'
    )
    expect(page.body).to include(
      'Receipts must be provided.'
    )
  end

  def check_incentives
    expect(page.body).to include('We are offering')
    expect(page).to have_tag('a.editable', text: 'a cash incentive of £10.50')
    expect(page.body).to include('for participation in this session')
  end
end

World PreviewChecker
