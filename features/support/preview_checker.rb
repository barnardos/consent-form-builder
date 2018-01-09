##
# Check the content for the happy path where everything is
# filled in
#
module PreviewChecker
  def check_researcher
    researcher_path = research_session_question_path(
      StepCompletions::BULLYING_SLUG, 'researcher', 'edit-preview' => 1
    )
    expect(page).to have_selector("a.editable[href='#{researcher_path}']", text: @job_title)
    expect(page).to have_selector("a.editable[href='#{researcher_path}']", text: @researcher_name)
    expect(page).to have_selector("a.editable[href='#{researcher_path}']", text: @researcher_phone)
    expect(page).to have_selector("a.editable[href='#{researcher_path}']", text: @researcher_email)
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
      expect(page.body).to have_link(methodology_display_name, class: 'editable')
    end
  end

  def check_recording
    @recording_methods.each do |recording_method|
      expect(page.body).to include(recording_method.downcase)
    end
  end

  def check_storing
    expect(page).to have_content("Barnardo’s will hold research data for #{@shared_duration}")
    expect(page).to have_content(
      'Any research recordings will have names and personal details removed and replaced'
    )
  end

  def check_where_when
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
    expect(page.body).to include('As a thank you, we will give your child')
    expect(page).to have_tag('a.editable', text: 'a cash incentive of £10.50')
  end
end

World PreviewChecker
