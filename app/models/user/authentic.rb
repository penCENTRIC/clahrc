class User
  module Authentic
    def self.included(base)
      base.attr_accessible :email, :password, :password_confirmation

      base.acts_as_authentic do |config|
        config.validates_uniqueness_of_email_field_options = {
          :case_sensitive => false,
          :if => :email_changed?,
          :message => t('users.error_messages.email_not_unique'),
          :scope => base.validations_scope
        }

        config.validates_length_of_password_field_options = {
          :if => :has_no_credentials?,
          :minimum => 7,
          :on => :update
        }

        config.validates_length_of_password_confirmation_field_options = { 
          :if => :has_no_credentials?,
          :minimum => 7,
          :on => :update
        }
      end
      
      base.validates_constancy_of :email
      
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      # Confirm the user
      def confirm!
        unless self.confirmed?
          update_attribute :confirmed, true

          deliver_activation_confirmation!
          
          # Add to new members group - there should be a better way to do this!
          begin
            Group.find(22).members << self
          rescue
            nil
          end
        end
      end

      # Send an email to the user confirming that their account has been activated
      def deliver_activation_confirmation!
        reset_perishable_token!

        UserNotifier.deliver_activation_confirmation(self)
      end

      # Send an email to the user with instructions to activate their account
      def deliver_activation_instructions!
        reset_perishable_token!

        UserNotifier.deliver_activation_instructions(self)
      end

      # Send an email to the user with instructions to reset their password
      def deliver_password_reset_instructions!
        reset_perishable_token!

        UserNotifier.deliver_password_reset_instructions(self)
      end

      private
        # +true+ if the user has no password
        def has_no_credentials?
          crypted_password.blank?
        end
    end
  end
end
