###################################################
### Step defs used for both Foreman and phpIPAM ###
###################################################

Given /^I am on the "([^\"]*)" login page$/ do |app|
  $app = get_app(app)
  visit($app.login_page)
end

Then /^I should see "([^\"]*)"$/ do |text|
  expect(page).to have_content(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  expect(page).to have_no_content(text)
end

When /^I log in to "([^\"]*)" as an admin user$/ do |app|
  $app.login
end

Then /^I click on "([^\"]*)"$/ do |link|
  click_link(link)
end

When /^I click the "([^\"]*)" button$/ do |button_text|
  click_button(button_text)
end

# This step is used in a number of tests for navigating to different pages in both apps. 
# Since we are switching from app to app in a lot of tests, we need to re-evalaute the app var 
# each time here to ensure we are redirecting to the appropriate page in the correct app.
Given /^I am on the "([^\"]*)" "([^\"]*)" page$/ do |app, page_name|
  $app = get_app(app)
  visit($app.get_page(page_name))
end


#######################################
### Step defs used for only phpIPAM ###
#######################################

When /^I create a "([^\"]*)" section$/ do |section_name|
  $section_id = $app.create_section(section_name)
end

When /^I create a "([^\"]*)" subnet$/ do |cidr|
  $app.create_subnet(cidr)
end

When /^I click on the "([^\"]*)" section$/ do |section|
  visit($app.section_page($section_id))
end

When /^I reserve the first IPv6 address$/ do 
  $app.reserve_first_ipv6_address
end

When /^I click on the "([^\"]*)" address$/ do |ip|
  find(:xpath, '//*[@id="content"]/div/div[5]/div[1]/span[1]').click if ip == ".1"
  find(:xpath, '//*[@id="content"]/div/div[5]/div[1]/span[2]').click if ip == ".2"
end

When /^I click the Delete button for section "([^\"]*)"$/ do |section_name|
  $app.delete_section(section_name)
end

#######################################
### Step defs used for only Foreman ###
#######################################

Then /^I create an "([^\"]*)" subnet called "([^\"]*)" for "([^\"]*)"$/ do |protocol, name, cidr|
  subnet = cidr.split('/')
  ipv6 = protocol == "IPv6" ? true : false
  $app.create_subnet(name, subnet[0], subnet[1], ipv6)
end

Then /^I create a host called "([^\"]*)"$/ do |host_name|
  $app.create_host(host_name)
end

Then /^I add an "([^\"]*)" interface with the subnet "([^\"]*)" with a mac address of "([^\"]*)"$/ do |protocol, subnet, mac|
  $app.create_interface(protocol, subnet, mac)
end

Then /^I add a second "([^\"]*)" interface with the subnet "([^\"]*)" with a mac address of "([^\"]*)"$/ do |protocol, subnet, mac|
  $app.create_interface(protocol, subnet, mac)
end

Then /^I should see "([^\"]*)" as the next available "([^\"]*)" address for the first interface$/ do |ip, protocol|
  interface_id = $app.get_interface_id
  suggested_ip = $app.get_suggested_ip(protocol, interface_id)
  suggested_ip == ip
end

Then /^I should see "([^\"]*)" as the next available "([^\"]*)" address for the second interface$/ do |ip, protocol|
  interface_id = $app.get_interface_id
  suggested_ip = $app.get_suggested_ip(protocol, interface_id)
  suggested_ip == ip
end

Then /^I save the interface$/ do
  $app.save_interface
end

Then /^I change the suggested IPv4 address to "([^\"]*)"$/ do |ip|
  $app.overwrite_ip4(ip)
end

Then /^I should see the "([^\"]*)" address "([^\"]*)" reserved in phpIPAM$/ do |protocol, ip|
  sleep (0.5)
  $ipam_app = get_app('phpIPAM')
  visit($ipam_app.section_page($ipam_app.get_test_section_id))
  click_link $ipam_app.get_subnet_by_protocol(protocol)
  expect(page).to have_link(ip)
end

Then /^I should not see the "([^\"]*)" address "([^\"]*)" reserved in phpIPAM$/ do |protocol, ip|
  sleep (0.5)
  $ipam_app = get_app('phpIPAM')
  visit($ipam_app.section_page($ipam_app.get_test_section_id))
  click_link $ipam_app.get_subnet_by_protocol(protocol)
  expect(page).to_not have_link(ip)
end

When /^I click the Delete button for "([^\"]*)"$/ do |subnet|
  $app.delete_subnet(subnet)
end

Then /^I confirm the deletion$/ do
  page.driver.browser.switch_to.alert.accept
  sleep (1.0) # Small pause here to allow for post confirmation processes to complete
end
