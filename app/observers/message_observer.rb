class MessageObserver < ActiveRecord::Observer
  def after_create(message)
    if message.type.blank?
      message.sender.sent_messages.create(:message => message)
    end
  end
end
