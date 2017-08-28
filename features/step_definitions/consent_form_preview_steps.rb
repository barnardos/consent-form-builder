Then(/^I should see the age-appropriate consent form preview$/) do
  expect(page).to have_content('my child')
  expect(page).to have_content('your child')
end

And(/^I should see a way to print it$/) do
  expect(page).to have_tag('a', with: { class: 'print-link' })
end

And(/^it should have a place for name, signature and date$/) do
  expect(page).to have_content('Name')
  expect(page).to have_content('Signature')
  expect(page).to have_content('Date')
end
