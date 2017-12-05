And(/^I should see confirmation that this is a preview$/) do
  expect(page).to have_content('Research session preview')
end

And(/^I should see each methodology selected$/) do
  # Interview, Usability as set in question_steps.rb
  expect(page).to have_content('a one-on-one interview')
  expect(page).to have_content('an observation of trying out (the new tool) we’re designing')
end

And(/^I should see the focus of the research along with why$/) do
  expect(page).to have_content(@topic)
  expect(page).to have_content(@purpose)

  expect(page).to have_content(
    'It is important that we test the current and future tools and services'
  )
end

And(/^I should see a humanised indication of recording methods used$/) do
  expect(page).to have_content('voice recording, video recording, and written notes')
end

And(/^I should see links back to edit things that I provided$/) do
  ResearchSession::Steps.instance.step_keys.each do |step|
    expect(page).to have_tag('a', href: Regexp.new("^/research-sessions/[0-9]*/questions/#{step}/"))
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

Then(/^I should see an updated preview$/) do
  expect(page).to have_content(@new_phone_number)
end
