class MessageRecipientObserver < ActiveRecord::Observer
  def after_create(message_recipient)
    unless message_recipient.nil?
      message_recipient.recipient.received_messages.create(:message => message_recipient.message)
    end
  end
end
