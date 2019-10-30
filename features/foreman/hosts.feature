Feature: Add Hosts to Foreman and ensure phpIPAM integration is working

Background: 
  Given I am on the "Foreman" login page
  When I log in to "Foreman" as an admin user
  Then I should see "Admin User"
  Given I am on the "phpIPAM" login page
  Then I should see "Please login"
  When I log in to "phpIPAM" as an admin user
  Then I should see "Logged in as  Administrator"

@javascript
Scenario: Ensure that MAC address is required before getting next available IP
  Given I am on the "Foreman" "hosts" page
  When I click on "Create Host"
  Then I create a host called "Test Host"
  And I add an "IPv4" interface with the subnet "Available Subnet" with a mac address of ""
  Then I should see "You must specify a MAC address before selecting the External IPAM subnet"

@javascript
Scenario: Adding a host to Foreman with 2 IPv4 interfaces should also reserve 2 IP's in phpIPAM
  Given I am on the "Foreman" "hosts" page
  When I click on "Create Host"
  Then I create a host called "IPv4 Host"
  And I add an "IPv4" interface with the subnet "Available Subnet" with a mac address of "00:0a:95:9d:68:10"
  Then I should see "100.10.10.1" as the next available "IPv4" address for the first interface
  And I save the interface
  And I add a second "IPv4" interface with the subnet "Available Subnet" with a mac address of "00:0a:95:9d:68:11"
  Then I should see "100.10.10.2" as the next available "IPv4" address for the second interface
  And I save the interface
  When I click the "Submit" button
  Then I should see "Successfully created ipv4host.example.com"
  And I should see the "IPv4" address "100.10.10.1" reserved in phpIPAM
  And I should see the "IPv4" address "100.10.10.2" reserved in phpIPAM

@javascript
Scenario: Adding a host to Foreman with 2 IPv6 interfaces should also reserve 2 IP's in phpIPAM
  Given I am on the "Foreman" "hosts" page
  When I click on "Create Host"
  Then I create a host called "IPv6 Host"
  And I add an "IPv6" interface with the subnet "Available Subnet" with a mac address of "00:0a:95:9d:68:20"
  Then I should see "2001:db8:abcd:12::1" as the next available "IPv6" address for the first interface
  And I save the interface
  And I add a second "IPv6" interface with the subnet "Available Subnet" with a mac address of "00:0a:95:9d:68:21"
  Then I should see "2001:db8:abcd:12::2" as the next available "IPv6" address for the second interface
  And I save the interface
  When I click the "Submit" button
  Then I should see "Successfully created ipv6host.example.com"
  And I should see the "IPv6" address "2001:db8:abcd:12::1" reserved in phpIPAM
  And I should see the "IPv6" address "2001:db8:abcd:12::2" reserved in phpIPAM

@javascript
Scenario: Ensure that using an IP address that is already reserved throws an appropriate error
  Given I am on the "Foreman" "hosts" page
  When I click on "Create Host"
  Then I create a host called "Another Test Host"
  And I add an "IPv4" interface with the subnet "Available Subnet" with a mac address of "00:0a:95:9d:68:30"
  Then I change the suggested IPv4 address to "100.10.10.1"
  And I save the interface
  When I click the "Submit" button
  Then I should see "Some of the interfaces are invalid"
  And I click the "Edit" button
  Then I should see "This IP address has already been reserved in External IPAM"

@javascript
Scenario: Delete the host from Foreman with 2 IPv4 interfaces should also delete the IP's from phpIPAM
  Given I am on the "Foreman" "hosts" page
  When I click on "ipv4host.example.com"
  Then I click on "Delete"
  And I confirm the deletion
  Then I should see "Successfully deleted ipv4host.example.com"
  And I should not see the "IPv4" address "100.10.10.1" reserved in phpIPAM
  And I should not see the "IPv4" address "100.10.10.2" reserved in phpIPAM

@javascript
Scenario: Delete the host from Foreman with 2 IPv6 interfaces should also delete the IP's from phpIPAM
  Given I am on the "Foreman" "hosts" page
  When I click on "ipv6host.example.com"
  Then I click on "Delete"
  And I confirm the deletion
  Then I should see "Successfully deleted ipv6host.example.com"
  And I should not see the "IPv6" address "2001:db8:abcd:12::1" reserved in phpIPAM
  And I should not see the "IPv6" address "2001:db8:abcd:12::2" reserved in phpIPAM