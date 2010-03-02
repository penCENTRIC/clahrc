module SentMessagesHelper
  def link_to_sent_message(sent_message)
    unless sent_message.nil?
      link_to truncate(sanitize(sent_message.subject_to_s)), my_sent_message_path(sent_message)
    end
  end
  
  def link_to_sent_messages
    link_to t('sent_messages.index'), my_sent_messages_path, :class => 'sent message'
  end
end
