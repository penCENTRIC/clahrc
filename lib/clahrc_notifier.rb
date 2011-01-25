require 'app_settings'

class ClahrcNotifier
  TWITTER_CONSUMER_KEY = AppSettings.twitter.consumer_key
  TWITTER_CONSUMER_SECRET = AppSettings.twitter.consumer_secret
  TWITTER_ACCESS_TOKEN = AppSettings.twitter.access_token
  TWITTER_ACCESS_SECRET = AppSettings.twitter.access_secret
  
  attr_accessor :user, :activity, :preference, :notification

  def initialize(user, activity, preference, notification)
    self.user = user
    self.activity = activity
    self.preference = preference
    self.notification = notification
  end
  
  def dispatch
    send(preference.notification_type.downcase.gsub(' ', '_'))
  end

  # These could be some clever pluggable mechanisms, but for now we just have a method
  # that fits the operation of #dispatch
  
  def twitter_dm
    if user.profile.twitter.present?
      auth = Twitter::OAuth.new(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET)
      auth.authorize_from_access(TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_SECRET)
      client = Twitter::Base.new(auth)
      msg = "d #{user.profile.twitter} #{activity[:activity].describe}"
      Rails.logger.info(msg)
      client.update(msg)
      notification.sent = true
    end
  rescue
  end
  
  def immediate_email
    notification.sent = ActivityNotifier.deliver_immediate(user, activity, activity[:event].capitalize)
  end
  
  def email_digest
    notification.for_digest = true
  end
end