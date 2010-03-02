class MessageRecipient < ActiveRecord::Base
  belongs_to :message
  belongs_to :recipient, :class_name => 'User'
end
