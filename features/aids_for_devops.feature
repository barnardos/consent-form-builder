Feature:
  As a person managing an issue with the app
  I want to see a link to our current release
  So that I can know whether what I'm testing fixes my issue

  Scenario: We are in production
    Given we are in production
    When I visit the start page
    Then I should see a short-SHA link to the current version
    When I start to create a form
    Then I should still see a short-SHA link to the current version

  Scenario: We are in development
    Given we are in development
    When I visit the start page
    Then I should see a short-SHA link to the current version
    When I start to create a form
    Then I should still see a short-SHA link to the current version
