class ReceivedMessageActivity < Activity
  def received_message
    trackable
  end
  
  def describe
    %{
      #{received_message.sender} sent you a message:
      
      Subject: #{received_message.subject_to_s}

      #{received_message.body_to_s}
      
      To view this message, please click the following link:
      
      #{my_received_message_url(received_message, :host => 'my.clahrc.net')}
    }
  end

  def prepare_notifications
    notification = { :event => 'private message', :status => 'posted', :activity => self }
    received_message.recipients.each { |user| user.process_notification(notification) }
  end
end
