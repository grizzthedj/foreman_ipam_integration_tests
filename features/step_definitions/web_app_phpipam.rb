require 'selenium-webdriver'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end

class IpamApp
  include Capybara::DSL
  
  def login
    fill_in 'username', :with => $ipam_username
    fill_in 'password', :with => $ipam_password
    click_button('Login')
  end

  def create_section(name)
    fill_in 'name', :with => name
    fill_in 'description', :with => 'Cuke Section!'
    click_button('Add')
    find(:xpath, '//*[@id="content"]/div[2]/div[2]/div[2]/table/tbody/tr/td[9]/div/button[2]')['data-sectionid']
  end

  def create_subnet(cidr)
    fill_in 'subnet', :with => cidr
    fill_in 'description', :with => 'Cuke Subnet!'
    click_button('Add')
  end

  def delete_section(section_name)
    find(:xpath, '//*[@id="content"]/div[2]/div[2]/div[2]/table/tbody/tr/td[9]/div/button[2]/i').click
    click_button('Delete')
    find(:xpath, '//*[@id="editSectionSubmitDelete"]').click
  end

  def get_test_section_id
    visit(get_page('subnets'))
    click_link "Cucumber Dev"
    current_path.split('/')[2].to_s
  end

  def get_subnet_by_protocol(protocol)
    protocol == "IPv4" ? "100.10.10.0/29" : "2001:db8:abcd:12::/124"
  end

  def reserve_first_ipv6_address
    find(:xpath, '//*[@id="content"]/div/div[1]/table/tbody/tr[19]/td/div/div[3]/a[1]/i').click
    click_button('Add IP')
  end

  def login_page
    $ipam_url + '/login'
  end

  def section_page(section_id)
    $ipam_url + "/subnets/#{section_id.to_s}/"
  end

  def get_page(page_name)
    case page_name
      when "subnets"
        $ipam_url + '/subnets/'
      when "sections"
        $ipam_url + '/administration/sections/'
      else 
        $ipam_url
    end
  end
end