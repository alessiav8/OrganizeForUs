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
And I fill in "EmailUser" with "al@gm.com"
And I press "Create Partecipation"
Then I should see "Member was succesfully added"
And I follow "End"
Then I should see "Work group"


