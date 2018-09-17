And(/^I should see confirmation that this is a preview$/) do
  expect(page).to have_content('Consent form')
end

And(/^I should see each methodology selected$/) do
  # Interview, Usability as set in question_steps.rb
  expect(page).to have_content('One-on-one interview')
  expect(page).to have_content('Group discussion')
end

And(/^I should see the focus of the research along with why$/) do
  # Issue with updating Cucumber from version 2 to 3 with relation to testing
  # multiline text, which is why the gsubs are used, see links:
  # https://github.com/teamcapybara/capybara/blob/master/UPGRADING.md
  # https://gist.github.com/awesome/7584024
  expect(page).to have_content(@topic.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip)
  expect(page).to have_content(@purpose.gsub(/^[\s\t]*/, '').gsub(/[\s\t]*\n/, ' ').strip)

  expect(page).to have_content(
    'We do research with young people because we know it improves our services.'
  )
end

And(/^I should see a humanised indication of recording methods used$/) do
  expect(page).to have_content('video recording, voice recording, and researcher’s notes')
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
