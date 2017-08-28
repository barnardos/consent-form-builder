Feature:
  As a researcher
  I want to generate combinations of printed consent materials
  So that I can get consent from parents and participants without making mistakes

  Scenario: The session is for a child
    When I provide full session details for a child-age cohort
    Then I should see the session review page
    And I should see confirmation that this is a preview
    And I should see the formatted focus of the research along with why
    And I should see an age-specific text block for each research methodology selected
    And I should see a humanised indication of recording methods used
    And I should see links back to edit things that I provided
    And I should see the age-appropriate consent form preview
    And it should have a place for name, signature and date
    And I should see a way to print it

  Scenario: I am using a research methodology or recording method that is not in the list
    Given I have arrived at the methodologies step
    When I provide an 'Other' methodology
    And I provide an 'Other' recording method
    And I fill in the remaining steps
    Then I should see the session review page
    And I should see my 'Other' methodology
    And I should see my 'Other' recording method
