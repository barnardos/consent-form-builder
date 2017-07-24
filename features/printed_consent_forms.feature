Feature:
  As a researcher
  I want to generate combinations of printed consent materials
  So that I can get consent from parents and participants without making mistakes

  Scenario: There is one combination of sheet and form
    When I provide session details – a single age cohort, recording method and incentive details
    Then I should see the session review page



