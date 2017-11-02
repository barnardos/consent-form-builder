Given(/^a session exists in a previewable state$/) do
  @session = FactoryBot.create :research_session, :previewable
end

When(/^I visit its preview page$/) do
  visit research_session_preview_path(research_session_id: @session.slug)
end

And(/^I create a copy$/) do
  click_button 'Create a copy'
end

Then(/^I should see a way of naming the new session based on the existing name$/) do
  save_and_open_page
  expect(page).to have_content('Please name your copied session')
  expect(page).to have_content("#{@session.name} (copy)")
end

When(/^I name it and continue$/) do
  @new_session_name = 'This is a copied session'
  @new_session_slug = @new_session_name.downcase.tr(' ', '-')
  fill_in 'Please name your copied session', with: @new_session_name

  click_button 'Continue'
end

Then(/^I should see a preview of the new session$/) do
  expect(page).to have_current_path(
    research_session_preview_path(research_session_id: @new_session_slug)
  )
end
