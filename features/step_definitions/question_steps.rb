When(/^I provide session details – a single age cohort, recording method and incentive details$/) do
  visit '/'
  click_link 'Create new form'
  choose 'Under 12 years old'
  click_button 'Continue'

  fill_in 'What is the name of the research participant?',
          with: 'Namey McNamerson'
  click_button 'Continue'

  check 'methodologies[]-interview'
  click_button 'Continue'

  check 'recording_methods[]-audio'
  click_button 'Continue'

  fill_in 'What is the focus of your research project?',
          with: 'Fresnel lenses and the under-5s'
  click_button 'Continue'

  within '.first-researcher' do
    fill_in 'Full name', with: 'Rachel Researcher'
    fill_in 'Telephone number', with: '012345678'
    fill_in 'Email', with: 'rachel@researcher.com'
  end

  within '.second-researcher' do
    fill_in 'Full name', with: 'Steve Secondresearcher'
  end
  click_button 'Continue'

  choose 'incentive-yes'

  choose 'payment_type-cash'
  fill_in 'Incentive value', with: '10.50'

  click_button 'Continue'
end

Then(/^I should see the session review page$/) do
  expect(page).to have_content('Congraturation! You Sucsess!')
end
