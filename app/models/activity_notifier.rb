class ActivityNotifier < ActionMailer::Base
  def immediate(user, activity, brief_description)
    subject    "CLAHRCnet: #{brief_description}"
    recipients user.email
    from       'no-reply@clahrc.net'
    
    body       :user => user, :notification => activity
  end

  def digest(user, notifications)
    subject    'CLAHRCnet: Recent Activity'
    recipients user.email
    from       'no-reply@clahrc.net'
    body       :user => user, :notifications => notifications
  end

end