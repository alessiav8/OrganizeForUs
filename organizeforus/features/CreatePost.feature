Feature: a member of a group want to create a post

Scenario: Create post succesfully
    Given There is a user
    When I try to logged the user in
    Then I should be on the home page
    Given the show page of a specific group 
    Then I move to the Posts section
    Then I should see "Posts"
    And I press "new_post_hidden"
    Then I create post with title Post1 and body Description
    Then I should be on Post1 page


Scenario: Create post unsuccesfully
    Given There is a user
    When I try to logged the user in
    Then I should be on the home page
    Given the show page of a specific group 
    Then I move to the Posts section
    Then I should see "Posts"
    And I press "new_post_hidden"
    Then I create post with title Post1 and body empty
    Then It should go wrong