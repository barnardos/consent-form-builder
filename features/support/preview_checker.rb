##
# Check the content for the happy path where everything is
# filled in
#
module PreviewChecker
  def check_researcher
    researcher_path = research_session_question_path(
      StepCompletions::BULLYING_SLUG, 'researcher', 'edit-preview' => 1
    )
    expect(page).to have_selector(
      "a.Output-link[href='#{researcher_path}']",
      text: @job_title
    )
    expect(page).to have_selector(
      "a.Output-link[href='#{researcher_path}']",
      text: @researcher_name
    )
    expect(page).to have_selector(
      "a.Output-link[href='#{researcher_path}']",
      text: @researcher_phone
    )
    expect(page).to have_selector(
      "a.Output-link[href='#{researcher_path}']",
      text: @researcher_email
    )
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
      expect(page.body).to have_link(methodology_display_name, class: 'Output-link')
    end
  end

  def check_recording
    @recording_methods.each do |recording_method|
      expect(page.body).to include(recording_method)
    end
  end

  def check_storing
    expect(page).to have_content(
      "Barnardo’s will delete the research data #{@shared_duration} "\
      'after the project ends. Personal data is stored securely.'
    )
    expect(page).to have_content(
      'Any research recordings will have names and personal details removed and replaced'
    )
  end

  def check_where_when
    expect(page).to have_tag('a.Output-link', text: @session_duration)
    expect(page).to have_tag('a.Output-link', text: @session_location)
    expect(page).to have_tag('a.Output-link', text: @held_on)
    expect(page).to have_tag('a.Output-link', text: @what_to_bring)
  end

  def check_expenses
    expect(page.body).to have_content(
      'Expenses are allow of up to £50.00 for travel, £20.00 for food, '\
      'and £10.00 for other expenses.'
    )
    expect(page.body).to include(
      'Receipts must be provided.'
    )
  end

  def check_incentives
    expect(page.body).to have_content(
      'As a thank you, we\'ll give the child £10.50, in cash'
    )
    expect(page).to have_tag('[data-field="incentive_value"] > a.Output-link', text: '£10.50')
  end
end

World PreviewChecker
