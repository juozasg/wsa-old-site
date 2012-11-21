require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

require 'config/app.rb'

# Basic settings:
# domain     - The hostname to SSH to
# deploy_to  - Path to deploy into
# repository - Git repo to clone from (needed by mina/git)
# user       - Username in the  server to SSH to (optional)

set :domain, @app_host
set :deploy_to, "/var/www/#{@app_host}"
set :repository, "#{@app_repository}"
set :user, 'root'
# set :port, '30000'

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    puts settings.inspect
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue "export UNICORNPID=$(ps aux | grep 'unicorn_rails master' | grep -v grep | cut -d ' ' -f 6);
             kill -USR2 $UNICORNPID;
             sleep 5;
             kill -QUIT $UNICORNPID"
    end
  end
end
