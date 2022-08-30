Feature: User could create a group

    Scenario: Create group
        Given There is a user
        When I try to logged the user in
        Then I should be on the home page
        And I press Create group
        Then I should see "Create new group"
        And I fill in "Name" with "GruppoWork"
        And I fill in "Description" with "Gruppo1"
        And I check "Work"
        And I fill in "Startdata" with "2022/07/08"
        And I fill in "Enddata" with "2022/07/10"
        And I fill in "Hours" with "10"
        And I fill in "Max" with "10"
        And I press "Continue"
        Given There is another user with an account
        And I fill in "EmailUser" with "alex@gm.com"
        And I press "Create Partecipation"
        Then I should see "Member was succesfully added"
        Given There is another user without an account
        And I fill in "EmailUser" with "email_di_esempio@gm.com"
        And I press "Create Partecipation"
        Then I should see "Sent invite"
        And I follow "End"
        Then I should see "Work group"


    Scenario: Not succesfully creation
        Given There is a user 
        When I try to logged the user in
        Then I should be on the home page 
        And I press Create group
        Then I should see "Create new group"
        And I fill in "Description" with "Gruppo1"
        And I fill in "Startdata" with "08/07/2022"
        And I fill in "Enddata" with "10/07/2022"
        And I check "Work"
        And I press "Continue"
        Then I should see "error prohibited this group from being saved"


