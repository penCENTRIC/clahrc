set :domain, "dptserver2.ex.ac.uk"
set :user, "matthew"
set :deploy_to, "/var/www/domains/clahrc.net/web/public"
set :rails_env, "staging"
set :branch, "staging"

role :app, "#{domain}"
role :web, "#{domain}"
role :db, "#{domain}", :primary => true