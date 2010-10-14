User.find_each do |user|
  NotificationPreference.build_or_retrieve_top_level_for_user(user)
end