When(/^I provide full session details for every step$/) do
  create_new_form

  complete_researcher_step
  complete_topic_step
  complete_methodologies_step
  complete_recording_methods_step
  complete_data_step
  complete_time_equipment_step
  complete_expenses_step
  complete_incentive_step

  click_link "Respondents who can't give consent"
end

Then(/^I should see the session review page$/) do
  step 'I should see confirmation that this is a preview'
end

Given(/^I have arrived at the methodologies step$/) do
  create_new_form

  complete_researcher_step
  complete_topic_step
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
  complete_data_step
  complete_time_equipment_step
  complete_expenses_step

  complete_incentive_step
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
