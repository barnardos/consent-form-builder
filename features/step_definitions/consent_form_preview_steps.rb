Then(/^I should see the age-appropriate consent form preview$/) do
  expect(page).to have_content('Preview: Declaration of consent')
  expect(page).to have_content('my child')
  expect(page).to have_content('your child')
end

And(/^I should see a way to print it$/) do
  expect(page).to have_tag('a', with: { class: 'print-link' })
end
