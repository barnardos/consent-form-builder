Given(/^a session exists in a previewable state$/) do
  @existing_session = FactoryBot.create :research_session, :previewable
end

When(/^I visit its preview page$/) do
  visit research_session_preview_path(research_session_id: @existing_session.slug)
end

Then(/^I should see a way of naming the new session based on the existing name$/) do
  expect(page).to have_content('Please name your research session')
  expect(page).to have_selector("input[value='#{@existing_session.name} (copy)']")
end

When(/^I name it and continue$/) do
  @new_session_name = 'This is a copied session'
  @new_session_slug = @new_session_name.downcase.tr(' ', '-')
  fill_in 'Please name your research session', with: @new_session_name

  click_button 'Continue'
end

Then(/^I should see a preview of a new session$/) do
  expect(page).to have_current_path(
    research_session_preview_path(research_session_id: @new_session_slug)
  )
end

And(/^I go to create a copy$/) do
  click_link 'Create a copy'
end
