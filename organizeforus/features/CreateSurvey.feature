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
    Then I should see "Survey created"



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

Scenario: Create survey not succesfully not authorized
    Given There is another user 
    When I try to logged the another user in
    Then he should be on the home page 
    And he is a member of a group
    And he move into the group  
    Then he move to the Surveys section
    Then he should see "Surveys List"
    And he press New
    Then he should see "Not Authorized"
  