Given /^"([^"]*)" with password "([^"]*)" is a confirmed member$/ do |email, password|
  user = Factory :user, :email => email, :password => password, :password_confirmation => password
  user.confirm!
end

When /^I sign in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Given %{"#{email}" with password "#{password}" is a confirmed member}
  When %{I go to the sign in page}
  And %{I fill in "Email address" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Login"}
end
