set :application, "clahrc"

set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:penCENTRIC/clahrc.git"
set :git_shallow_clone, 1

set :default_branch, "master"
set :default_stage, "staging"

default_run_options[:pty] = true

set :default_environment, { 
  'PATH' => "/usr/local/rvm/gems/ree-1.8.7-2010.02/bin:/usr/local/rvm/gems/ree-1.8.7-2010.02@global/bin:/usr/local/rvm/rubies/ree-1.8.7-2010.02/bin:/usr/local/bin:$PATH",
  'RUBY_VERSION' => 'ree-1.8.7-2010.02',
  'GEM_HOME' => '/usr/local/rvm/gems/ree-1.8.7-2010.02',
  'GEM_PATH' => '/usr/local/rvm/gems/ree-1.8.7-2010.02:/usr/local/rvm/gems/ree-1.8.7-2010.02@global' 
}

namespace :deploy do
  after "deploy:setup", "deploy:setup_shared_paths"

  after "deploy:symlink", "deploy:symlink_shared_paths", "deploy:symlink_app_settings", "deploy:symlink_db_settings"
  
  task :setup_shared_paths do
    run "mkdir -p #{shared_path}/assets"
    run "mkdir -p #{shared_path}/avatars"
    run "mkdir -p #{shared_path}/bundle"
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/db/sphinx"
  end
  
  task :symlink_shared_paths do
    run "ln -nfs #{shared_path}/assets #{current_path}/assets"
    run "ln -nfs #{shared_path}/avatars #{current_path}/public/avatars"
    run "ln -nfs #{shared_path}/bundle #{current_path}/bundle"
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end

  task :symlink_app_settings do
    run "ln -nfs #{shared_path}/config/app_settings.rb #{current_path}/config/app_settings.rb"
  end

  task :symlink_db_settings do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end
end

# Bundler
namespace :bundle do
  desc "[internal] Install the gems specified by the Gemfile"
  task :install, :roles => :app do
    run <<-BASH
      if [ -f #{File.join(release_path, 'Gemfile')} ]; then
        cd #{release_path};
        bundle install --path ./bundle --without development test;
      fi; true
    BASH
  end
end

after "deploy:update", "bundle:install"

# Passenger
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
end

# Staging
set :stages, [ 'testing', 'staging', 'production' ]
set :branches, `git branch -r`.split(/\n/).collect { |i| i.gsub /.*origin\/(master|staging|production)?/, "" }.reject { |i| i.empty? }.uniq

namespace :production do
  desc "Set the target stage to 'production'."
  task :default do
    set :branch, "production"
    set :stage, "production"
    
    server "clahrc.net", :app, :web, :db
    
    set :rails_env, "#{stage}"
    set :deploy_to, "/opt/webs/clahrc.net/docs"
  end
end

namespace :staging do
  desc "Set the target stage to 'staging'."
  task :default do
    set :branch, "staging"
    set :stage, "staging"
    
    server "dptserver2.ex.ac.uk", :app, :web, :db
    
    set :rails_env, "#{stage}"
    set :deploy_to, "/opt/webs/clahrc.net/docs/#{stage}"    
  end
    
  desc "[internal] Ensure that a stage has been selected."
  task :ensure do
    if !exists?(:stage)
      if exists?(:default_stage)
        logger.important "No stage specified. Defaulting to '#{default_stage}'"
        find_and_execute_task(default_stage)
      else
        abort "No stage specified. Please specify one of: #{stages.join(', ')} (e.g. 'cap #{stages.first} #{ARGV.last}')"
      end
    end
  end
end

on :start, "staging:ensure", :except => stages + branches.map { |i| "testing:#{i}" }

# Testing
namespace :testing do
  desc "Set the target stage to 'testing'."
  task :default do
    if !exists?(:branch)
      if exists?(:default_branch)
        logger.important "No branch specified. Defaulting to '#{default_branch}'"
        find_and_execute_task("testing:#{default_branch}")
      else
        abort "No branch specified. Please specify one of: #{branches.join(', ')} (e.g. 'cap testing:#{branches.first} #{ARGV.last}')"
      end
    end

    set :stage, "testing"
    
    server "dptserver2.ex.ac.uk", :app, :web, :db
    
    set :rails_env, "#{stage}"
    set :deploy_to, "/opt/webs/clahrc.net/docs/#{stage}"    
  end

  desc "[internal] Set the target stage to 'testing' with branch 'master'."
  task :master do
    set :branch, "master"
    find_and_execute_task("testing")
  end
  
  branches.each do |name|
    desc "Set the target stage to 'testing' with branch '#{name}'."
    task(name) do
      set :branch, name
      find_and_execute_task("testing")
    end
  end
end

# ThinkingSphinx
namespace :thinking_sphinx do
  desc "Generate the Sphinx configuration file using ThinkingSphinx's settings"
  task :configure, :once => true, :roles => :app do
    run <<-BASH
      cd #{current_path};
      rake thinking_sphinx:configure RAILS_ENV=#{stage}
    BASH
  end

  desc "Index the Sphinx searchd daemon using ThinkingSphinx's settings"
  task :index, :roles => :app do
    run <<-BASH
      cd #{current_path};
      rake thinking_sphinx:index RAILS_ENV=#{stage}
    BASH
  end

  before "thinking_sphinx:index", "thinking_sphinx:configure"
  
  desc "Start the Sphinx searchd daemon using ThinkingSphinx's settings"
  task :start, :roles => :app do
    run <<-BASH
      cd #{current_path};
      rake thinking_sphinx:start RAILS_ENV=#{stage}
    BASH
  end

  before "thinking_sphinx:start", "thinking_sphinx:configure"
  
  desc "Start the Sphinx searchd daemon using ThinkingSphinx's settings"
  task :stop, :roles => :app do
    run <<-BASH
      cd #{current_path};
      rake thinking_sphinx:stop RAILS_ENV=#{stage}
    BASH
  end
end

before "deploy:update", "thinking_sphinx:stop"
after "deploy:update", "thinking_sphinx:start"

# Whenever
namespace :crontab do
  desc "Update the crontab file"
  task :update, :roles => :app, :except => { :no_release => true } do
    run <<-BASH
      cd #{release_path};
      whenever -i CLAHRC_NET --update-crontab --set environment=#{stage}&output=#{shared_path}/log/cron.log&path=#{release_path};
    BASH
  end
end

after "deploy:update", "crontab:update"
