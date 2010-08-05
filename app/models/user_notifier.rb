class UserNotifier < ActionMailer::Base
  def activation_instructions(user)
    subject    "CLAHRC Community Registration"
    recipients user.email
    from       'no-reply@clahrc.net'
    sent_on    Time.now
    body       :email => user.email, :activation_url => edit_user_url(:host => 'community.clahrc.net', :id => user.perishable_token)
  end
  
  def activation_confirmation(user)
    subject    "CLAHRC Community Registration Details"
    recipients user.email
    from       'no-reply@clahrc.net'
    sent_on    Time.now
    body       :email => user.email, :password => user.password
  end

  def password_reset_instructions(user)
    subject    "CLAHRC Community Password"
    recipients user.email
    from       'no-reply@clahrc.net'
    sent_on    Time.now
    body       :email => user.email, :password_reset_url => edit_password_url(:host => 'community.clahrc.net', :id => user.perishable_token)
  end
end
