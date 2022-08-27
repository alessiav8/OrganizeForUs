Feature: Create a survey

Scenario: Create survey succesfully
    Given There is a user
    When I try to logged the user in
    Then I should be on the home page
    Given the show page of a specific group 
    Then I move to the Surveys section
    Then I should see "Surveys List"
    And I press New
    And I fill in "Title" with "Survey1"
    And I fill in "Body" with "Survey Description"
    And I fill in "Option" with "yes"
    And I press "Save"
    Then I should see "You are being redirected."



Scenario: Create survey not succesfully
    Given There is a user
    When I try to logged the user in
    Then I should be on the home page
    Given the show page of a specific group 
    Then I move to the Surveys section
    Then I should see "Surveys List"
    And I press New
    And I fill in "Body" with "Survey Description"
    And I fill in "Option" with "yes"
    And I press "Save"
    Then I am on Survey creation path