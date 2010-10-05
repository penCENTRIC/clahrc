Feature: Sending notifications
  In order to keep up to date with goings on
  A CLAHRC member
  Wants to receive timely notifications of activity
  
  Background:
    Given "jys@ketlai.co.uk" with password "apassword" is a confirmed member
    And "otheruser@example.com" with password "apassword" is a confirmed member
    And I am using the subdomain "community"

  @wip
  Scenario: Someone has requested my friendship
    Given "jys@ketlai.co.uk" has asked to receive friendship requests immediately

    When I sign in as "otheruser@example.com" with password "apassword"
    And I go to the profile page for "jys@ketlai.co.uk"
    Then show me the page
    
    When I follow "Add as friend"
    Then "jys@ketlai.co.uk" should get an email notification
    
  Scenario: Someone has accepted my offer of friendship
  Scenario: I have been sent a private message
  Scenario: Someone has posted a new message in one of my groups
  Scenario: Someone has posted a new message in a thread I'm following
  Scenario: My request to join a new group has been approved
