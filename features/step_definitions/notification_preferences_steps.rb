Given /^the following setting_notification_preferences:$/ do |setting_notification_preferences|
  SettingNotificationPreferences.create!(setting_notification_preferences.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) setting_notification_preferences$/ do |pos|
  visit setting_notification_preferences_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following setting_notification_preferences:$/ do |expected_setting_notification_preferences_table|
  expected_setting_notification_preferences_table.diff!(tableish('table tr', 'td,th'))
end
