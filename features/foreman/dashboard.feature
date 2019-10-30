Feature: IPAM Dashboard renders sections and subnets

Background: 
  Given I am on the "Foreman" login page
  When I log in to "Foreman" as an admin user
  Then I should see "Admin User"

@javascript
Scenario: Ensure that sections and subnets are being rendered
  Given I am on the "Foreman" "IPAM" page
  When I click on "Cucumber Dev" 
  Then I should see "100.10.10.0/29"
  And I should see "200.10.10.0/30"
