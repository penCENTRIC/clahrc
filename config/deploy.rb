#require 'vendor/plugins/thinking-sphinx/recipes/thinking_sphinx'

set :stages, %w(staging production)
set :default_stage, 'staging'

require 'capistrano/ext/multistage'

default_run_options[:pty] = true

set :application, 'clahrc'
set :repository, 'git@github.com:penCENTRIC/clahrc.git'
set :use_sudo, false

set :domain, 'dptserver2.ex.ac.uk' # 'dptserver3.ex.ac.uk'
set :user, 'matthew' # 'web641'

set :scm, 'git'
set :git_enable_submodules, true
set :git_shallow_clone, 1

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

set :default_environment, { 
  'PATH' => "/opt/ruby-enterprise-1.8.7-2010.02/bin:$PATH",
  'GEM_HOME' => '/opt/ruby-enterprise-1.8.7-2010.02/lib/ruby/gems/1.8',
  'GEM_PATH' => '/opt/ruby-enterprise-1.8.7-2010.02/lib/ruby/gems/1.8'
}

namespace :deploy do
  task :start, :roles => :app do
    # do nothing
  end

  task :stop, :roles => :app do
    # do nothing
  end
    
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  before 'deploy', 'thinking_sphinx:stop'
  
  after 'deploy:setup', 'deploy:setup_shared_paths'

  after 'deploy:update_code', 'bundler:bundle_new_release'

  after 'deploy:symlink', 'deploy:symlink_shared_paths', 'deploy:symlink_app_settings', 'deploy:symlink_db_settings'
  
  after 'deploy', 'thinking_sphinx:configure', 'thinking_sphinx:start', 'crontab:update'
  
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

  task :symlink_db_settings do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end
end

namespace :thinking_sphinx do
  task :configure, :roles => :app do
    run "cd #{release_path} && rake thinking_sphinx:configure RAILS_ENV=#{stage}"
  end
  
  task :start, :roles => :app do
    run "cd #{release_path} && rake thinking_sphinx:start RAILS_ENV=#{stage}"
  end

  task :stop, :roles => :app do
    run "cd #{current_path} && rake thinking_sphinx:stop RAILS_ENV=#{stage}"
  end
end

namespace :crontab do
  desc 'Update the crontab file'
  task :update, :roles => :app do
    run "cd #{release_path} && whenever -i CLAHRC_NET --update-crontab --set environment=#{stage}&output=#{shared_path}/log/cron.log&path=#{release_path}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run "cd #{release_path} && if [ -f Gemfile ] ; then mkdir -p #{shared_dir} ; fi"
    run "cd #{release_path} && if [ -f Gemfile ] ; then ln -s #{shared_dir} #{release_dir} ; fi"
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && if [ -f Gemfile ] ; then bundle install --without test ; fi"
  end
end
