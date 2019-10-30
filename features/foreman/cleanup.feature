Feature: Delete test subnets from Foreman

Background: 
  Given I am on the "Foreman" login page
  When I log in to "Foreman" as an admin user
  Then I should see "Admin User"

@javascript
Scenario: Delete the subnet with available addresses from Foreman
  Given I am on the "Foreman" "subnets" page
  When I click the Delete button for "Available Subnet"
  And I confirm the deletion
  Then I should see "Successfully deleted"

@javascript
Scenario: Delete the subnet with no available addresses from Foreman
  Given I am on the "Foreman" "subnets" page
  When I click the Delete button for "Full Subnet"
  And I confirm the deletion
  Then I should see "Successfully deleted"

@javascript
Scenario: Delete the IPv6 subnet from Foreman
  Given I am on the "Foreman" "subnets" page
  When I click the Delete button for "IPv6 Subnet"
  And I confirm the deletion
  Then I should see "Successfully deleted"