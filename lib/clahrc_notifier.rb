class ClahrcNotifier
  TWITTER_CONSUMER_KEY = '8UTBbxcMBqt613xKVAKzvw'
  TWITTER_CONSUMER_SECRET = '2Y811lOeyhfqpmrWoyLn4hVHKubZgmQ5ZW1l30ftZY'
  TWITTER_ACCESS_TOKEN = '20201554-IFUGE6RG7EekDAxL56cg7hBWHTiYHIuNuIkHOOubB'
  TWITTER_ACCESS_SECRET = 'bb1GPH4ePbKqENY3aKt7fP7ZtMIsMuyYt93LbxWsc'
  
  attr_accessor :user, :activity, :preference

  def initialize(user, activity, preference)
    self.user = user
    self.activity = activity
    self.preference = preference
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
    end
  rescue
  end
  
  def immediate_email
    ActivityNotifier.deliver_immediate(user, activity, activity[:event].capitalize)
  end
  
  def digest_email
    # We presume that the activity stream will have captured this and so don't do anything
  end
end