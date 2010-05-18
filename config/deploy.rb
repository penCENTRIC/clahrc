#require 'vendor/plugins/thinking-sphinx/recipes/thinking_sphinx'

default_run_options[:pty] = true

set :application, "clahrc"
set :domain,      "dptserver3.ex.ac.uk"
set :user,        "web641"
set :repository,  "git@github.com:penCENTRIC/clahrc.git"
set :use_sudo,    false
set :deploy_to,   "/opt/webs/clahrc.net/docs"

set :scm,                   "git"
set :branch,                "master"
set :git_enable_submodules, true
set :git_shallow_clone,     1

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  after "deploy:setup", "deploy:setup_shared_paths"

  before "deploy", "thinking_sphinx:stop"
  
  after "deploy:symlink", "deploy:symlink_shared_paths", "deploy:symlink_app_settings"
  
  after "deploy", "deploy:configure_database_connection", "thinking_sphinx:configure", "thinking_sphinx:start", "crontab:update"
  
  task :configure_database_connection, :roles => :app do
    require "yaml"

    set :password, proc { Capistrano::CLI.password_prompt("Password for remote production database: ") }

    buffer = YAML::load_file('config/database.yml.template')

    buffer['production']['database'] = 'clahrc2'
    buffer['production']['username'] = 'clahrc2'
    buffer['production']['password'] = password

    put YAML::dump(buffer), "#{deploy_to}/current/config/database.yml", :mode => 0664
  end
  
  task :setup_shared_paths do
    run "mkdir -p #{shared_path}/assets"
    run "mkdir -p #{shared_path}/avatars"
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/db/sphinx"
  end
  
  task :symlink_shared_paths do
    run "ln -nfs #{shared_path}/assets #{current_path}/assets"
    run "ln -nfs #{shared_path}/avatars #{current_path}/public/avatars"
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end

  task :symlink_app_settings do
    run "ln -nfs #{shared_path}/config/app_settings.rb #{current_path}/config/app_settings.rb"
  end
end

namespace :thinking_sphinx do
  task :configure, :roles => [:app] do
    run "cd #{release_path} && #{sudo} rake thinking_sphinx:configure RAILS_ENV=production"
  end
  
  task :start, :roles => [:app] do
    run "cd #{release_path} && #{sudo} rake thinking_sphinx:start RAILS_ENV=production"
  end

  task :stop, :roles => [:app] do
    run "cd #{current_path} && #{sudo} rake thinking_sphinx:stop RAILS_ENV=production"
  end
end

namespace :crontab do
  desc "Update the crontab file"
  task :update, :roles => :db do
    run "cd #{release_path} && #{sudo} whenever -i CLAHRC_NET --update-crontab --user #{user}"
  end
end
