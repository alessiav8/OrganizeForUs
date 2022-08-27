Feature: Person should create an account 

Scenario: User created an account 
    Given I am on the home page
    When I follow Sign up
    Then I should be on Registration page
    When I fill in "Name" with "ale"
    And I fill in "Surname" with "v"
    And I fill in "Username" with "al"
    And I fill in "Email" with "al@gmail.com"
    And I fill in "Birthday" with "2000/08/07"
    And I fill in "Password" with "ciaociao"
    And I fill in "Password confirmation" with "ciaociao"
    And I press "Sign up"
    Then I should see "Welcome! You have signed up successfully."


Scenario: User not successfully be created 
    Given I am on the home page
    When I follow Sign up
    Then I should be on Registration page
    And I fill in "Surname" with "v"
    And I fill in "Username" with "al"
    And I fill in "Email" with "al@gmail.com"
    And I fill in "Birthday" with "2000/08/07"
    And I fill in "Password" with "ciaociao"
    And I fill in "Password confirmation" with "ciaociao"
    And I press "Sign up"
    Then I should see "Name can't be blank"


