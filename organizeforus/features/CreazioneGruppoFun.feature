Feature: User could create a group

Scenario: Create group succesfully
    Given There is a user
    When I try to logged the user in
    Then I should be on the home page
    And I press Create group
    Then I should see "Create new group"
    And I fill in "Name" with "Gruppo1"
    And I fill in "Description" with "Gruppo1"
    And I check "Fun"
    And I fill in "Startdata" with "2022-08-07"
    And I fill in "Enddata" with "2022-10-07"
    And I fill in "Hours" with "10"
    And I press "Continue"
    Then I should see "Starting adding members"
    And I fill in "EmailUser" with "al@gm.com"
    And I press "Create Partecipation"
    Then I should see "Member was succesfully added"
    And I follow "End"
    Then I should see "Fun group"



Scenario: Not succesfully creation
    Given There is a user 
    When I try to logged the user in
    Then I should be on the home page 
    And I press Create group
    Then I should see "Create new group"
    And I fill in "Description" with "Gruppo1"
    And I fill in "Startdata" with "08/07/2022"
    And I fill in "Enddata" with "10/07/2022"
    And I check "Fun"
    And I press "Continue"
    Then I should see "error prohibited this group from being saved"





