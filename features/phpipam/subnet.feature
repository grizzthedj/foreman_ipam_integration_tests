Feature: Add Subnets to phpIPAM

Background: 
  Given I am on the "phpIPAM" login page
  Then I should see "Please login"
  When I log in to "phpIPAM" as an admin user
  Then I should see "Logged in as  Administrator"

@javascript
Scenario: Add a subnet with available addresses to phpIPAM
  Given I am on the "phpIPAM" "subnets" page
  When I click on the "Cucumber Dev" section
  Then I should see "Available subnets"
  When I click the "Add subnet" button
  And I create a "100.10.10.0/29" subnet
  Then I should see "Available subnets"
  And I should see "100.10.10.0/29"
  And I should not see "Error"

@javascript
Scenario: Add a second subnet with no available addresses to phpIPAM
  Given I am on the "phpIPAM" "subnets" page
  When I click on the "Cucumber Dev" section
  Then I should see "Available subnets"
  When I click the "Add subnet" button
  And I create a "200.10.10.0/30" subnet
  Then I should see "Available subnets"
  And I should see "200.10.10.0/30"
  And I should not see "Error"

@javascript
Scenario: Add an IPv6 subnet with available addresses to phpIPAM
  Given I am on the "phpIPAM" "subnets" page
  When I click on the "Cucumber Dev" section
  Then I should see "Available subnets"
  When I click the "Add subnet" button
  And I create a "2001:db8:abcd:12::/124" subnet
  Then I should see "Available subnets"
  And I should see "2001:db8:abcd:12::/124"
  And I should not see "Error"

@javascript
Scenario: Reserve all addresses in second subnet
  Given I am on the "phpIPAM" "subnets" page
  When I click on the "Cucumber Dev" section
  And I click on "200.10.10.0/30"
  Then I click on the ".1" address
  And I click the "Add IP" button
  Then I click on the ".2" address
  And I click the "Add IP" button
  Then I should see "Free: 0 (0%)"

@javascript
Scenario: Reserve first address in IPv6 subnet
  Given I am on the "phpIPAM" "subnets" page
  When I click on the "Cucumber Dev" section
  And I click on "2001:db8:abcd:12::/124"
  And I reserve the first IPv6 address
  Then I should see "Used: 1 | Free: 15 (93.75%)"