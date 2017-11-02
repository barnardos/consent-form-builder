@wip
Feature: Create a copy
  As a researcher
  I want to create a new session from an existing session
  So that I can avoid typing everything from scratch again

Scenario: A suitable session exists
  Given a session exists in a previewable state
  When I visit its preview page
  And I create a copy
  Then I should see a way of naming the new session based on the existing name
  When I name it and continue
  Then I should see a preview of the new session

