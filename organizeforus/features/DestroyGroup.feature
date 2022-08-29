Feature: As Administrator of a group I want to destroy in

    Scenario: Destroy group succesfully 
        Given There is a user 
        When I try to logged the user in
        Then I should be on the home page 
        Given the show page of a specific group 
        And I press "ButtonGroupDelete"
        Then I press "DestroyGroupWork"
        Then I should see "Group was successfully destroyed."

     Scenario: Destroy group not succesfully, user not authorized
        Given There is another user 
        When I try to logged the another user in
        Then he should be on the home page 
        And he is a member of a group
        And he move into the group 
        And he press "ButtonGroupDelete"
        Then I press "DestroyGroupWork"
        Then he should see "Not Authorized"