set :output, "/var/www/domains/clahrc.net/web/public/current/log/cron.log"
set :path, "/var/www/domains/clahrc.net/web/public/current" 

every 1.minute do
  rake "clahrc:notify"
end

every 1.hour do
  rake "thinking_sphinx:index"
end
