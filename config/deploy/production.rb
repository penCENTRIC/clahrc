set :domain, "dptserver3.ex.ac.uk"
set :user, "web641"
set :deploy_to, "/opt/webs/clahrc.net/docs"

role :app, "#{domain}"
role :web, "#{domain}"
role :db, "#{domain}", :primary => true