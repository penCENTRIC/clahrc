class MessageActivity < Activity
  def message
    trackable
  end

  def describe
    "#{message.sender} sent you a new message: '#{message.subject}'. Read it at #{my_received_messages_url(:host => 'my.clahrc.net')}"
  end

  def prepare_notifications
    notification = { :event => 'private message', :status => 'posted', :activity => self }
    message.recipients.each { |user| user.process_notification(notification) }
  end
end
