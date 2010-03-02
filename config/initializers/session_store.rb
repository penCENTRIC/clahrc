ActionController::Base.session = {
  :domain      => ENV['SESSION_DOMAIN']
  :key         => ENV['SESSION_KEY'],
  :secret      => ENV['SESSION_SECRET']
}
