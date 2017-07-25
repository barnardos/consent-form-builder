And(/^I should see confirmation that this is a preview$/) do
  expect(page).to have_content('Research session preview')
end

And(/^I should see an age\-specific text block for each research methodology selected$/) do
  # Interview, Usability as set in question_steps.rb
  expect(page).to have_content('Your child will be interviewed')
  expect(page).to have_content('Your child will be asked')
end
