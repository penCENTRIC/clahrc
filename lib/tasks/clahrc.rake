namespace :clahrc do
  desc "Notify users of activities"
  task :notify => :environment do
    Activity.all(:conditions => { :notified => false }, :order => 'created_at ASC').each do |activity|
      begin
        case activity
        when FriendshipActivity
          friendship = activity.friendship
        
          if friendship.confirmed?
            friendship.deliver_friendship_confirmation
          else
            friendship.deliver_friendship_request
          end
        when MembershipActivity
          membership = activity.membership
          
          if membership.confirmed?
            membership.deliver_membership_confirmation
          else
            membershup.deliver_membership_request
          end
        when ReceivedMessageActivity
          received_message = activity.received_message
        
          received_message.deliver_received_message_notification
        end
      rescue Exception => e
        Rails.logger.info(e.inspect)
        nil
      end
    
      activity.update_attribute :notified, true
    end
  end
end
