And(/^I should see confirmation that this is a preview$/) do
  expect(page).to have_content('Research session preview')
end

And(/^I should see an age\-specific text block for each research methodology selected$/) do
  # Interview, Usability as set in question_steps.rb
  expect(page).to have_content('Your child will be interviewed')
  expect(page).to have_content('Your child will be asked')
end

And(/^I should see the focus of the research along with why$/) do
  expect(page).to have_content(@focus)
  expect(page).to have_content('It is important that we test the current and future tools and services')
end

And(/^I should see a humanised indication of recording methods used$/) do
  expect(page).to have_content('audio, video, and written notes')
end

And(/^I should see which areas have been affected by what I chose$/) do
  some = 5..50
  expect(page).to have_tag('.highlight', count: some)
end

When(/^I click continue$/) do
  click_link 'Continue'
end
