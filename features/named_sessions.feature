Feature: Creating named sessions
  As a researcher
  I want to name my session
  So that I get memorable URLs and can make new sessions from existing ones

Scenario: A new session
  When I create a session with a name
  Then I should see that name in the URL

Scenario: A new session with an existing name
  Given there is an existing session with a name
  When I create a session with the same name
  Then I should see a disambiguated name in the URL
