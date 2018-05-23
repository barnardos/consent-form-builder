# frozen_string_literal: true

Then(/^I should see the age-appropriate consent form preview$/) do
  expect(page).to have_content('my child')
  expect(page).to have_content('your child')

  ResearchSession::Steps.instance.step_keys.each do |step|
    send :"check_#{step}"
  end
end

And(/^I should see a way to print it$/) do
  expect(page).to have_tag('form', with: { class: 'print-section' })
end

And(/^it should have a place for name, signature and date$/) do
  expect(page).to have_content('Name')
  expect(page).to have_content('Signature')
  expect(page).to have_content('Date')
end
