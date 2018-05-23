# frozen_string_literal: true

When(/^I create a session with (?:a|the same) name$/) do
  create_new_form
end

Then(/^I should see that name in the URL$/) do
  expect(page).to have_current_path(
    research_session_question_path(
      id: 'researcher',
      research_session_id: @session_name.downcase.strip.tr(' ', '-')
    )
  )
end

Given(/^there is an existing session with a name$/) do
  FactoryBot.create(:research_session, name: StepCompletions::BULLYING_NAME)
end

Then(/^I should see a disambiguated name in the URL$/) do
  uuid = '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'

  expect(page).to have_current_path(
    Regexp.new(
      "/research-sessions/#{@session_name.downcase.strip.tr(' ', '-')}-#{uuid}"\
      '/questions/researcher'
    )
  )
end
