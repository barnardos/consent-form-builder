When(/^I provide full session details for every step$/) do
  visit '/'

  click_button 'Create new form'

  within '[name="first-researcher"]' do
    fill_in 'Full name', with: 'Rachel Researcher'
    fill_in 'Telephone number', with: '012345678'
    fill_in 'Email', with: 'rachel@researcher.com'
  end

  within '[name="second-researcher"]' do
    fill_in 'Full name', with: 'Steve Secondresearcher'
  end

  click_button 'Continue'

  @topic = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
    Fresnel lenses and the under-5s
    This line break follows a br

    Whereas this becomes its own p
  TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

  @purpose = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
    PURPOSE: Fresnel lenses and the under-5s
    PURPOSE: This line break follows a br

    PURPOSE: Whereas this becomes its own p
  TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

  fill_in 'What is the research or participation session about?', with: @topic
  click_button 'Continue'

  fill_in 'Why are you doing this research or participation session?', with: @purpose
  click_button 'Continue'

  @methodologies = ['Interview', 'Usability testing']
  @methodologies.each do |methodology|
    check methodology
  end
  click_button 'Continue'

  @recording_methods = ['Audio', 'Video', 'Written notes']
  @recording_methods.each do |method|
    check method
  end
  click_button 'Continue'

  choose 'Just the team'
  @shared_duration = '1 year'
  @shared_usage = 'The data will be used to create better outcomes for more children'

  fill_in 'How long will this information be held for?', with: @shared_duration
  fill_in 'How will the data be used?', with: @shared_usage
  click_button 'Continue'

  @held_on = '27th September at 2pm'
  fill_in 'The session is held on (optional)', with: @held_on
  @session_duration = '5 minutes'
  fill_in 'How long will the session be? (optional)', with: @session_duration
  @session_location = 'Rockford House, Leeds'
  fill_in 'Where will the session be? (optional)', with: @session_location
  @what_to_bring = 'Nothing'
  fill_in 'What do participants need to bring? (optional)', with: @what_to_bring
  click_button 'Continue'

  fill_in 'If you allow travel expenses, what is the maximum allowed?', with: '50.00'
  fill_in 'If you allow food expenses, what is the maximum allowed?', with: '20.00'
  fill_in 'If you allow the participant to expense other items, '\
          'what is the maximum allowed?', with: '10.00'
  click_button 'Continue'

  choose 'Yes'

  choose 'Cash'
  fill_in 'Incentive value', with: '10.50'
  click_button 'Continue'

  click_link "Respondents who can't give consent"
end

Then(/^I should see the session review page$/) do
  step 'I should see confirmation that this is a preview'
end

Given(/^I have arrived at the methodologies step$/) do
  visit '/'
  click_button 'Create new form'

  within '[name="first-researcher"]' do
    fill_in 'Full name', with: 'Rachel Researcher'
    fill_in 'Telephone number', with: '012345678'
    fill_in 'Email', with: 'rachel@researcher.com'
  end

  within '[name="second-researcher"]' do
    fill_in 'Full name', with: 'Steve Secondresearcher'
  end
  click_button 'Continue'

  @topic = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
    Fresnel lenses and the under-5s
    This line break follows a br

    Whereas this becomes its own p
  TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

  @purpose = <<~TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK
    PURPOSE: Fresnel lenses and the under-5s
    PURPOSE: This line break follows a br

    PURPOSE: Whereas this becomes its own p
  TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

  fill_in 'What is the research or participation session about?', with: @topic
  click_button 'Continue'

  fill_in 'Why are you doing this research or participation session?', with: @purpose
  click_button 'Continue'
end

And(/^I should see an 'Other' checkbox for (.*) with a space to fill this in$/) do |attr|
  attr = attr.downcase.tr(' ', '_')
  expect(page).to have_tag('label', with: { for: "research_session_#{attr}_other" })
  expect(page).to have_tag('input', with: { id: "research_session_#{attr}_other" })
end

When(/^I fill in the 'Other' methodology$/) do
  check 'Other'

  @other_methodology = 'A.N. Other Methodology'
  fill_in 'What is the other methodology?', with: @other_methodology
end

When(/^I fill in the 'Other' recording method$/) do
  check 'Other'

  @other_recording_method = 'A.N. Other Recording Method'
  fill_in 'What is the other recording method?', with: @other_recording_method
end

And(/^I fill in the remaining steps$/) do
  choose 'Just the team'
  fill_in 'How long will this information be held for?', with: '1 year'
  fill_in 'How will the data be used?', with: 'Create better outcomes for more children'
  click_button 'Continue'

  @held_on = '27th September at 2pm'
  fill_in 'The session is held on (optional)', with: @held_on
  @session_duration = '5 minutes'
  fill_in 'How long will the session be? (optional)', with: @session_duration
  @what_to_bring = 'Nothing'
  fill_in 'What do participants need to bring? (optional)', with: @what_to_bring
  click_button 'Continue'

  fill_in 'If you allow travel expenses, what is the maximum allowed?', with: '50.00'
  fill_in 'If you allow food expenses, what is the maximum allowed?', with: '20.00'
  fill_in 'If you allow the participant to expense other items, '\
          'what is the maximum allowed?', with: '10.00'
  click_button 'Continue'

  choose 'Yes'

  choose 'Cash'
  fill_in 'Incentive value', with: '10.50'

  click_button 'Continue'
end

When(/^I provide an 'Other' methodology$/) do
  step "I should see an 'Other' checkbox for methodologies with a space to fill this in"
  step "I fill in the 'Other' methodology"
  step 'I click the continue button'
end

And(/^I provide an 'Other' recording method$/) do
  step "I should see an 'Other' checkbox for recording methods with a space to fill this in"
  step "I fill in the 'Other' recording method"
  step 'I click the continue button'
end

When(/^I begin a new session at the start$/) do
  visit '/'
  click_button 'Create new form'
end

When(/^I go back to a previous step$/) do
  click_link 'Rachel Researcher', match: :first
end

Then(/^I should see a way of getting straight back to the preview$/) do
  expect(page).to have_tag('button', text: 'Save and return')
end

When(/^I edit that step and continue$/) do
  @new_phone_number = '0772233445566'
  fill_in 'Telephone number', with: @new_phone_number
  click_button 'Save and return'
end
