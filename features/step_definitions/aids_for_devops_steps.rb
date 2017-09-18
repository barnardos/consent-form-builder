PRODUCTION_COMMIT_SHA = '267e26642e1f6abab769f01d8295643cb789f852'.freeze
DEVELOPMENT_COMMIT_SHA = `git rev-parse HEAD`.freeze

Given(/^we are in production$/) do
  @commit_sha = PRODUCTION_COMMIT_SHA
  ENV['HEROKU_SLUG_COMMIT'] = @commit_sha
end

Given(/^we are in development$/) do
  @commit_sha = DEVELOPMENT_COMMIT_SHA
  ENV['HEROKU_SLUG_COMMIT'] = nil
end

Then(/^I should (?:still )?see a short-SHA link to the current version$/) do
  within 'header' do
    expect(page).to have_tag(
      'a', text: @commit_sha[0..7],
           href: 'https://github.com/barnardos/consent-form-builder-rails/'\
                 'commit/169cea1b98b91af691ee5f029e3afcc9dea9408b',
           class: 'current-version'
    )
  end
end

When(/^I visit the home page$/) do
  visit '/'
end

When(/^I start to create a form$/) do
  click_button 'Create new form'
end
