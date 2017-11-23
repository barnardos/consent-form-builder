module StepCompletions
  BULLYING_NAME = ' Bullying in schools '.freeze
  BULLYING_SLUG = BULLYING_NAME.strip.downcase.tr(' ', '-').freeze

  def create_new_form
    visit '/'

    @session_name = BULLYING_NAME
    fill_in I18n.t('helpers.label.research_session.name'), with: @session_name

    click_button 'Create new form'
  end

  def complete_researcher_step
    within '[name="first-researcher"]' do
      @job_title = 'Director of Research'
      @researcher_name = 'Rachel Researcher'
      @researcher_phone = '012345678'
      @researcher_email = 'rachel@researcher.com'

      fill_in 'Job title', with: @job_title
      fill_in 'Full name', with: @researcher_name
      fill_in 'Telephone number', with: @researcher_phone
      fill_in 'Email', with: @researcher_email
    end

    within '[name="second-researcher"]' do
      fill_in 'Full name', with: 'Steve Secondresearcher'
    end

    click_button 'Continue'
  end

  def complete_topic_step
    @topic = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
      Fresnel lenses and the under-5s
      This line break follows a br

      Whereas this becomes its own p
    TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

    fill_in "Barnardo's is doing research to learn about", with: @topic

    @purpose = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
      PURPOSE: Fresnel lenses and the under-5s
      PURPOSE: This line break follows a br

      PURPOSE: Whereas this becomes its own p
    TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

    fill_in 'so that we can', with: @purpose
    click_button 'Continue'
  end

  def complete_methodologies_step
    @methodologies = ['Interview', 'Usability testing']
    @methodologies.each do |methodology|
      check methodology
    end
    click_button 'Continue'
  end

  def complete_recording_methods_step
    @recording_methods = ['Audio', 'Video', 'Written notes']
    @recording_methods.each do |method|
      check method
    end
    click_button 'Continue'
  end

  def complete_storing_step
    choose 'anonymised as we process it'
    @shared_duration = '1 year'

    fill_in 'How long will this information be held for?', with: @shared_duration
    click_button 'Continue'
  end

  def complete_where_when_step
    choose 'Yes'

    @held_on = '27th September at 2pm'
    fill_in 'The session is held on (optional)', with: @held_on
    @session_duration = '5 minutes'
    fill_in 'How long will the session be? (optional)', with: @session_duration
    @session_location = 'Rockford House, Leeds'
    fill_in 'The session will be held at (optional)', with: @session_location
    @what_to_bring = 'Nothing'
    fill_in 'What do participants need to bring? (optional)', with: @what_to_bring
    click_button 'Continue'
  end

  def complete_expenses_step
    choose 'Yes', name: 'research_session[expenses_enabled]'

    fill_in 'If you allow travel expenses, what is the maximum allowed?', with: '50.00'
    fill_in 'If you allow food expenses, what is the maximum allowed?', with: '20.00'
    fill_in 'If you allow the participant to expense other items, '\
            'what is the maximum allowed?', with: '10.00'
    click_button 'Continue'
  end

  def complete_incentives_step
    choose 'Yes'

    choose 'Cash'
    fill_in 'Incentive value', with: '10.50'
    click_button 'Continue'
  end
end

World StepCompletions
