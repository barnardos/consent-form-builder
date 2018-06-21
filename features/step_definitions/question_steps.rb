When(/^I provide full session details for every step$/) do
  create_new_form

  complete_researcher_step
  complete_topic_step
  complete_methodologies_step
  complete_recording_methods_step
  complete_storing_step
  complete_where_when_step
  complete_expenses_step
  complete_incentives_step
end

Then(/^I should see the session review page$/) do
  step 'I should see confirmation that this is a preview'
end

Given(/^I have arrived at the methodologies step$/) do
  create_new_form

  complete_researcher_step
  complete_topic_step
end

And(/^I should see an 'other' checkbox for (.*) with a space to fill this in$/) do |attr|
  attr = attr.downcase.tr(' ', '_')
  expect(page).to have_tag('label', with: { for: "research_session[other_#{attr}]" })
  expect(page).to have_tag('input', with: { id: "research_session[other_#{attr}]" })
end

When(/^I fill in the 'other' methodology$/) do
  check 'other'

  @other_methodology = 'A.N. Other Methodology'
  fill_in 'How will it be gathered?', with: @other_methodology
end

When(/^I fill in the 'other' recording method$/) do
  check 'other'

  @other_recording_method = 'A.N. Other Recording Method'
  fill_in 'How will it be recorded?', with: @other_recording_method
end

And(/^I fill in the remaining steps$/) do
  complete_storing_step
  complete_where_when_step
  complete_expenses_step

  complete_incentives_step
end

When(/^I provide an 'other' methodology$/) do
  step "I should see an 'other' checkbox for methodology with a space to fill this in"
  step "I fill in the 'other' methodology"
  step 'I click the continue button'
end

And(/^I provide an 'other' recording method$/) do
  step "I should see an 'other' checkbox for recording method with a space to fill this in"
  step "I fill in the 'other' recording method"
  step 'I click the continue button'
end

When(/^I go back to a previous step$/) do
  click_link 'Rachel Researcher', match: :first
end

Then(/^I should see a way of getting straight back to the preview$/) do
  expect(page).to have_tag(
    'input',
    class: 'Submit-element',
    type: 'submit',
    value: 'Save and return'
  )
end

When(/^I edit that step and continue$/) do
  @new_phone_number = '0772233445566'
  fill_in 'Phone', with: @new_phone_number
  click_button 'Save and return'
end
