require 'selenium-webdriver'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end

require 'capybara'
require 'capybara/dsl'
require 'cucumber'
require 'capybara/cucumber'
require 'time'
require_relative '../../config/app-config'

Capybara.register_driver :firefox do |app|
  browser_options = Selenium::WebDriver::Firefox::Options.new()
  browser_options.args << '--headless'

  Capybara::Selenium::Driver.new(app,
    browser: :firefox,
    options: browser_options
  )
end

Capybara.javascript_driver = :firefox

if ENV['FOREMAN_TEST_ENV']
  $env = ENV['FOREMAN_TEST_ENV']
else
  $env = "local"
end

$ipam_url = IpamEnvs[$env]['url']
$ipam_username = IpamEnvs[$env]['username']
$ipam_password = IpamEnvs[$env]['password']

$foreman_url = ForemanEnvs[$env]['url']
$foreman_username = ForemanEnvs[$env]['username']
$foreman_password = ForemanEnvs[$env]['password']

Capybara.configure do |config|
  config.run_server = false
  config.app_host = $foreman_url
  config.default_max_wait_time = 20
  config.default_driver = :selenium
  config.default_selector = :css
end

class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    # Use instance variable directly so we avoid starting the browser just to reset the session
    if @browser
      begin
        #@browser.manage.delete_all_cookies <= cookie deletion is commented out!
      rescue Selenium::WebDriver::Error::UnhandledError => e
        # delete_all_cookies fails when we've previously gone
        # to about:blank, so we rescue this error and do nothing
        # instead.
      end
      #@browser.navigate.to('about:blank')
    end
  end

  # if you comment out the following after run all scenarios the browser will not quit
  # def quit
  # end
end
