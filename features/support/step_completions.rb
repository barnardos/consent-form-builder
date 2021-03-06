module StepCompletions
  BULLYING_NAME = ' Bullying in schools '.freeze
  BULLYING_SLUG = BULLYING_NAME.strip.downcase.tr(' ', '-').freeze

  def create_new_form
    visit new_research_session_path

    @session_name = BULLYING_NAME
    fill_in I18n.t('helpers.label.research_session.name'), with: @session_name

    click_button 'Create new form'
  end

  def complete_researcher_step
    @job_title = 'Director of Research'
    @researcher_name = 'Rachel Researcher'
    @researcher_phone = '012345678'
    @researcher_email = 'rachel@researcher.com'

    fill_in 'Job title', with: @job_title
    fill_in 'Full name', with: @researcher_name
    fill_in 'Phone', with: @researcher_phone
    fill_in 'Email', with: @researcher_email

    click_button 'Continue'
  end

  def complete_topic_step
    @topic = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
      Fresnel lenses and the under-5s
      This line break follows a br

      Whereas this becomes its own p
    TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

    fill_in 'What does Barnardo’s hope to learn about?', with: @topic

    @purpose = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
      PURPOSE: Fresnel lenses and the under-5s
      PURPOSE: This line break follows a br

      PURPOSE: Whereas this becomes its own p
    TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

    fill_in 'What outcomes does Barnardo’s want to have?', with: @purpose
    click_button 'Continue'
  end

  def complete_methodologies_step
    @methodologies = [
      Methodologies::CHOICES.select { |choice| choice[:id] == 'interview' }.first[:label],
      Methodologies::CHOICES.select { |choice| choice[:id] == 'focusgroup' }.first[:label]
    ]
    @methodologies.each do |methodology|
      check methodology
    end
    click_button 'Continue'
  end

  def complete_recording_methods_step
    @recording_methods = ['Video recording', 'Voice recording', 'Researcher’s notes']
    @recording_methods.each do |method|
      check method
    end
    click_button 'Continue'
  end

  def complete_storing_step
    choose 'It won’t be'
    @shared_duration = '1 year'

    fill_in 'How long will research data be held after the project ends?', with: @shared_duration
    click_button 'Continue'
  end

  def complete_where_when_step
    choose 'Yes'

    @held_on = '27th September at 2pm'
    fill_in 'When (optional)', with: @held_on
    @session_duration = '5 minutes'
    fill_in 'Duration (optional)', with: @session_duration
    @session_location = 'Rockford House, Leeds'
    fill_in 'Where (optional)', with: @session_location
    @what_to_bring = 'Nothing'
    fill_in 'Participants need to bring (optional)', with: @what_to_bring
    click_button 'Continue'
  end

  def complete_expenses_step
    choose 'Yes', name: 'research_session[expenses_enabled]'

    fill_in 'Travel', with: '50.00'
    fill_in 'Food', with: '20.00'
    fill_in 'Other', with: '10.00'
    click_button 'Continue'
  end

  def complete_incentives_step
    choose 'Yes'

    choose 'Cash'
    fill_in 'Amount', with: '10.50'
    click_button 'Continue'
  end
end

World StepCompletions
