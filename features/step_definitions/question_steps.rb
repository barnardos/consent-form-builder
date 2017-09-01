When(/^I provide full session details for a child-age cohort$/) do
  visit '/'
  click_link 'Create new form'

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
    Fresnel lenses and the under-5s
    This line break follows a br

    Whereas this becomes its own p
  TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

  fill_in 'What is the research or participation session about?', with: @topic
  click_button 'Continue'

  fill_in 'Why are you doing this research or participation session?', with: @purpose
  click_button 'Continue'

  @methodologies = [:interview, :usability]
  @methodologies.each do |methodology|
    check "methodologies[]-#{methodology}"
  end
  click_button 'Continue'

  @recording_methods = [:audio, :video, :written]
  @recording_methods.each do |method|
    check "recording_methods[]-#{method}"
  end
  click_button 'Continue'

  choose 'Just the team'
  fill_in 'How long will this information be held for?', with: '1 year'
  fill_in 'How will the data be used?', with: 'Create better outcomes for more children'
  click_button 'Continue'

  within '#start_datetime' do
    select '2017', from: 'research_session_start_datetime_1i', visible: false
    select 'May', from: 'research_session_start_datetime_2i', visible: false
    select '10', from: 'research_session_start_datetime_3i', visible: false
    select '11', from: 'research_session_start_datetime_4i', visible: false
    select '30', from: 'research_session_start_datetime_5i', visible: false
  end
  fill_in 'How long will the session be? (optional)', with: '5 minutes'
  fill_in 'What do participants need to bring? (optional)', with: 'Nothing'
  click_button 'Continue'

  fill_in 'Travel expense limit', with: '50.00'
  fill_in 'Food expense limit', with: '20.00'
  click_button 'Continue'

  choose 'incentive-1'

  choose 'payment_type-cash'
  fill_in 'Incentive value', with: '10.50'

  click_button 'Continue'

  click_link "Respondents who can't give consent"
end

Then(/^I should see the session review page$/) do
  step 'I should see confirmation that this is a preview'
end

Given(/^I have arrived at the methodologies step$/) do
  visit '/'
  click_link 'Create new form'

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
    Fresnel lenses and the under-5s
    This line break follows a br

    Whereas this becomes its own p
  TEXT_WITH_DOUBLE_AND_SINGLE_LINEBREAK

  fill_in 'What is the research or participation session about?', with: @topic
  click_button 'Continue'

  fill_in 'Why are you doing this research or participation session?', with: @purpose
  click_button 'Continue'
end

And(/^I should see an 'Other' checkbox for (.*) with a space to fill this in$/) do |attr|
  attr = attr.downcase.tr(' ', '_')
  expect(page).to have_tag('label', with: { for: "#{attr}[]-other" })
  expect(page).to have_tag('input', with: { id: "#{attr}[]-other" })
  expect(page).to have_tag('input', with: { id: "#{attr}[]-other" })
end

When(/^I fill in the 'Other' methodology$/) do
  check 'methodologies[]-other'

  @other_methodology = 'A.N. Other Methodology'
  fill_in 'What is the other methodology?', with: @other_methodology
end

When(/^I fill in the 'Other' recording method$/) do
  check 'recording_methods[]-other'

  @other_recording_method = 'A.N. Other Recording Method'
  fill_in 'What is the other recording method?', with: @other_recording_method
end

And(/^I fill in the remaining steps$/) do
  choose 'Just the team'
  fill_in 'How long will this information be held for?', with: '1 year'
  fill_in 'How will the data be used?', with: 'Create better outcomes for more children'
  click_button 'Continue'

  within '#start_datetime' do
    select '2017', from: 'research_session_start_datetime_1i', visible: false
    select 'May', from: 'research_session_start_datetime_2i', visible: false
    select '10', from: 'research_session_start_datetime_3i', visible: false
    select '11', from: 'research_session_start_datetime_4i', visible: false
    select '30', from: 'research_session_start_datetime_5i', visible: false
  end
  fill_in 'How long will the session be? (optional)', with: '5 minutes'
  fill_in 'What do participants need to bring? (optional)', with: 'Nothing'
  click_button 'Continue'

  fill_in 'Travel expense limit', with: '50.00'
  fill_in 'Food expense limit', with: '20.00'
  click_button 'Continue'

  choose 'incentive-1'

  choose 'payment_type-cash'
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
