class ReceivedMessageNotifier < ActionMailer::Base
  def received_message_notification(received_message)
    subject    "[CLAHRC] New message"
    recipients received_message.user.email
    from       'clahrc@exeter.ac.uk'
    sent_on    received_message.updated_at
    body       :received_message => received_message
  end
end
