module MessagesHelper
  def link_to_inbox
    unread_messages_count = current_user.unread_messages.count
    
    if unread_messages_count == 0
      link_to_received_messages
    else
      link_to t('received_messages.index') + " [#{unread_messages_count}]", unread_my_received_messages_path, :title => pluralize(unread_messages_count, 'unread message'), :class => 'unread messages'
    end
  end
  
  def link_to_new_message(recipient)
    case recipient
    when User
      link_to t('messages.new'), new_member_message_path(recipient), :class => 'new message'
    when Group
      link_to t('messages.new'), new_group_message_path(recipient), :class => 'new message'
    else
      # do nothing
    end
  end

  def links_to_recipients(recipients)
    unless recipients.blank?
      recipients.collect { |recipient| link_to_member recipient.user }.to_sentence + '.'
    end
  end
end
