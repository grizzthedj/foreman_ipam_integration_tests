Feature: Delete Section from phpIPAM

Background: 
  Given I am on the "phpIPAM" login page
  Then I should see "Please login"
  When I log in to "phpIPAM" as an admin user
  Then I should see "Logged in as  Administrator"

@javascript
Scenario: Delete the test Section from phpIPAM
  Given I am on the "phpIPAM" "sections" page
  When I click the Delete button for section "Cucumber Dev"
  Then I should see "No sections configured!"