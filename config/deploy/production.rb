set :branch, 'production'
set :deploy_to, "/opt/webs/clahrc.net/docs/#{branch}"

set :rails_env, "#{branch}"