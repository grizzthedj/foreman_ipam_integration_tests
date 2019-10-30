Feature: Add Section to phpIPAM

Background: 
  Given I am on the "phpIPAM" login page
  Then I should see "Please login"
  When I log in to "phpIPAM" as an admin user
  Then I should see "Logged in as  Administrator"

@javascript
Scenario: Add a test Section to phpIPAM
  Given I am on the "phpIPAM" "sections" page
  Then I should see "Section management"
  When I click the "Add section" button
  Then I should see "Add section"
  When I create a "Cucumber Dev" section 
  Then I should see "Cucumber Dev"
  And I should not see "Section add failed"