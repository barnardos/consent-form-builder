And(/^I should see confirmation that this is a preview$/) do
  expect(page).to have_content('Research session preview')
end

And(/^I should see an age\-specific text block for each research methodology selected$/) do
  # Interview, Usability as set in question_steps.rb
  expect(page).to have_content('Your child will be interviewed')
  expect(page).to have_content('Your child will be asked')
end

And(/^I should see the formatted focus of the research along with why$/) do
  expect(page).to have_tag('.editable p', text: /^Fresnel lenses and the under-5s$/)
  expect(page).to have_tag('.editable p br')
  expect(page).to have_tag('.editable p', text: "Whereas this becomes its own p\n")

  expect(page).to have_content(
    'It is important that we test the current and future tools and services'
  )
end

And(/^I should see a humanised indication of recording methods used$/) do
  expect(page).to have_content('audio, video, and written notes')
end

And(/^I should see links back to edit things that I provided$/) do
  ResearchSession::Steps.instance.step_keys.each do |step|
    expect(page).to have_tag('a', href: question_path(step))
  end
end

When(/^I click the continue link$/) do
  click_link 'Continue'
end

When(/^I click the continue button$/) do
  click_button 'Continue'
end

Then(/^I should see my 'Other' methodology$/) do
  expect(page).to have_content(@other_methodology)
end

And(/^I should see my 'Other' recording method$/) do
  expect(page).to have_content(@other_recording_method)
end
