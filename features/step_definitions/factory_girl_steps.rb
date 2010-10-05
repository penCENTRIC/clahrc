Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :profile do |profile|
  profile.first_name "First"
  profile.last_name "Last"
end

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
  user.association :profile
end

Factory.factories.each do |name, factory|
  Given /^an? #{name} exists with an? (.*) of "([^"]*)"$/ do |attr, value|
    Factory(name, attr.gsub(' ', '_') => value)
  end
end
