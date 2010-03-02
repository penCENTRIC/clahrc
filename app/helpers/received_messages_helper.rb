module ReceivedMessagesHelper
  def link_to_received_messages
    link_to t('received_messages.index'), my_received_messages_path, :class => 'index message'
  end
  
  def link_to_received_message(received_message)
    unless received_message.nil?
      link_to_unless_current truncate(received_message.subject_to_s), my_received_message_path(received_message)
    end
  end
  
  def link_to_unread_received_messages
    unread_messages_count = current_user.unread_messages.count
    
    if unread_messages_count == 0
      link_to t('received_messages.unread'), unread_my_received_messages_path, :class => 'unread message'
    else
      link_to t('received_messages.unread') + " [#{unread_messages_count}]", unread_my_received_messages_path, :title => "#{unread_messages_count} #{pluralize(unread_messages_count, 'unread message')}", :class => 'unread message'
    end  
  end
end
