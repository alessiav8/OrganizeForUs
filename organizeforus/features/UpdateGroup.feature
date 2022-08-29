Feature: Group could be update

Scenario: Update group succesfully
    Given There is a user 
    When I try to logged the user in
    Then I should be on the home page 
    Given the show page of a specific group 
    And I am on Edit group page
    And I fill in "Name" with "Gruppo Updated"
    And I press "Update"
    Then I should be on the Group homepage

Scenario: Update group not succesfully for not valid attributes
    Given There is a user 
    When I try to logged the user in
    Then I should be on the home page 
    Given the show page of a specific group 
    And I am on Edit group page
    And I fill in "Name" with " "
    And I press "Update"
    Then I should see "Group was not successfully updated."

Scenario: Update group succesfully user authorized 
    Given There is a user 
    When I try to logged the user in
    Then I should be on the home page 
    Given the show page of a specific group 
    And I follow "EditGroup"
    Then I should see "Edit group"
    And I should be on Edit group page


Scenario: Update group not succesfully user not authorized 
    Given There is another user 
    When I try to logged the another user in
    Then he should be on the home page 
    And he is a member of a group
    And he move into the group 
    And he follow "EditGroup"
    Then he should see "Not Authorized"
    