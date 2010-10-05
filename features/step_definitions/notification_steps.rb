Given /^I am using the subdomain "(.+)"$/ do |sub|
  #host! "#{sub}.example.com"  #for webrat
  Capybara.default_host = "#{sub}.clahrc.local" #for Rack::Test
  Capybara.app_host = "http://#{sub}.clahrc.local:9887" if Capybara.current_driver == :culerity

  ################################################################################
  # As far as I know, you have to put all the {sub}.example.com entries that you're
  # using in your /etc/hosts file for the Culerity tests.  This didn't seem to be 
  # required for Rack::Test
  ################################################################################

end

Given /^"([^"]*)" has asked to receive friendship requests immediately$/ do |email|
  u = User.find_by_email(email)
  pref = u.notification_preferences.find_or_initialize_by_event('friend request')
  pref.notification_type = 'Immediate Email'
  pref.save
end

When /^visits to the profile page for "([^"]*)"$/ do |email|
  
end
