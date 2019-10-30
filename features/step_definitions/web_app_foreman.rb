require 'selenium-webdriver'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end

class ForemanApp
  include Capybara::DSL
  @@foreman_logged_in = false
  @@interface_count = 0

  def login
    if @@foreman_logged_in == false
      fill_in 'login_login', :with => $foreman_username
      fill_in 'login_password', :with => $foreman_password
      click_button('Log In')
      @@foreman_logged_in = true
    end
  end 

  def create_subnet(name, address, network_prefix, ipv6)
    fill_in 'subnet[name]', :with => name
    fill_in 'subnet[network]', :with => address
    fill_in 'subnet[cidr]', :with => network_prefix    
    
    if ipv6 
      choose('IPv6')                                            
      open_drop_down("subnet_ipam", 2)
    else
      open_drop_down("subnet_ipam", 3)
    end

    click_link('Proxies')
    open_drop_down("subnet_external_ipam_id", 0)
    click_button('Submit')
  end

  def create_host(host_name)
    @@interface_count = 0
    fill_in 'host[name]', :with => host_name
    open_drop_down("host_hostgroup_id", 0)
    sleep(1.0)  # Allow js to finish processing after host group selection
  end

  def create_interface(protocol, subnet, mac)
    click_link('Interfaces')
    
    if @@interface_count == 0
      click_button('Edit')
    else
      click_button('Add Interface')
    end

    if mac.length > 0
      mac_input = get_interface_mac_element
      mac_input.set(mac)
    end 

    interface_id = get_interface_id

    if protocol == "IPv6"
      open_drop_down("host_interfaces_attributes_" + interface_id + "_subnet6_id", 0)
    else
      open_drop_down("host_interfaces_attributes_" + interface_id + "_subnet_id", 0)
    end
  end

  def delete_subnet(subnet)
    find(:xpath, '//*[@id="content"]/table/tbody/tr[1]/td[7]/span/a').click
  end

  # This returns the generated interface id for the form input elements. The interface id is 0 for 
  # the existing interface that is already created in the UI, but when adding a new interface, 
  # a unique random number is generated.
  #
  # Examples: 
  # First(existing) input id:  host_interfaces_attributes_0_mac
  # Second input id:           host_interfaces_attributes_1572365963706_mac 
  def get_interface_id
    get_interface_mac_element[:id].split('_')[3] 
  end 

  def get_interface_mac_element
    elements = all(:xpath, '//*[starts-with(@id, "host_interfaces_attributes_")]')
    elements[0] 
  end 

  def open_drop_down(element_id, select_index)
    # Open the dropdown
    find(:xpath, '//*[@id="s2id_' + element_id + '"]').click               
    ipam_items = all(:xpath, '//*[starts-with(@id, "select2-result-label-")]')
    ipam_items[select_index].click  # Select the option 
  end
  
  def save_interface
    click_button('Ok')
    @@interface_count += 1
  end

  def overwrite_ip4(ip)
    find(:xpath, '//*[@id="host_interfaces_attributes_0_ip"]').set(ip)
  end

  def get_suggested_ip(protocol, interface_id)
    if protocol == "IPv4"
      ip_element = '//*[@id="host_interfaces_attributes_' + interface_id.to_s + '_ip"]'
    else
      ip_element = '//*[@id="host_interfaces_attributes_' + interface_id.to_s + '_ip6"]'
    end
    find(:xpath, ip_element).text
  end

  def login_page
    $foreman_url + '/users/login'
  end

  def get_page(page_name)
    case page_name
      when "subnets"
        $foreman_url + '/subnets'
      when "hosts"
        $foreman_url + '/hosts'
      when "IPAM"
        $foreman_url + '/ipam'
      else 
        $foreman_url
    end
  end
end
