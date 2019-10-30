Feature: Add Subnets to Foreman

Background: 
  Given I am on the "Foreman" login page
  When I log in to "Foreman" as an admin user
  Then I should see "Admin User"

@javascript
Scenario: Add a subnet with available addresses to Foreman
  Given I am on the "Foreman" "subnets" page
  When I click on "Create Subnet"
  Then I create an "IPv4" subnet called "Available Subnet" for "100.10.10.0/29"
  Then I should see "Successfully created Available Subnet"

@javascript
Scenario: Add a full subnet with no available addresses to Foreman
  Given I am on the "Foreman" "subnets" page
  When I click on "Create Subnet"
  Then I create an "IPv4" subnet called "Full Subnet" for "200.10.10.0/30"
  Then I should see "Successfully created Full Subnet"

@javascript
Scenario: Add an IPv6 subnet with available addresses to Foreman
  Given I am on the "Foreman" "subnets" page
  When I click on "Create Subnet"
  Then I create an "IPv6" subnet called "IPv6 Subnet" for "2001:db8:abcd:12::/124"
  Then I should see "Successfully created IPv6 Subnet"

@javascript
Scenario: Add a bogus subnet that should indicate that subnet does not exist
  Given I am on the "Foreman" "subnets" page
  When I click on "Create Subnet"
  Then I create an "IPv4" subnet called "Bogus Subnet" for "11.22.33.0/30"
  Then I should see "Subnet not found in the configured External IPAM instance"