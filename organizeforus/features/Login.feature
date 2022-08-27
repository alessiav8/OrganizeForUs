Feature: User want to sign in into his account

Scenario: Log in into OrganizeForUs succesfully
    Given There is a user 
    Given I am on Log in page
    And I fill in "Email" with "al@gm.com"
    And I fill in "Password" with "ciaociao"
    And I press "Log in"
    Then I should see "Welcome"

Scenario: Log in into OrganizeForUs failed
    Given There is a user 
    Given I am on Log in page
    And I fill in "Email" with "al@gm.com"
    And I fill in "Password" with "ciaoci"
    And I press "Log in"
    Then I should be on Log in page