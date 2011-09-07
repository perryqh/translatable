# For complete deployment instructions, see the following support guide:
# http://www.engineyard.com/support/guides/deploying_your_application_with_capistrano

require "eycap/recipes"

begin
  require "config/developers/logins"
rescue LoadError=>e
  EY_PASSWORD=proc{Capistrano::CLI.password_prompt('g5search user password:')}
  SCM_USERNAME="g5search"
  SCM_PASSWORD=proc{Capistrano::CLI.password_prompt('git g5search password:')}
end

# =================================================================================================
# ENGINE YARD REQUIRED VARIABLES
# =================================================================================================
# You must always specify the application and repository for every recipe. The repository must be
# the URL of the repository you want this recipe to correspond to. The :deploy_to variable must be
# the root of the application.

set :keep_releases,       5
set :application,         "translatable"
set :user,                "g5search"
set :password,            EY_PASSWORD
set :deploy_to,           "/data/#{application}"
set :monit_group,         "translatable"
set :runner,              "g5search"
set :repository,          "git@github.com:perry3819/translatable.git"
set :scm,                 :git
set :scm_username,        SCM_USERNAME
set :scm_password,        SCM_PASSWORD

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision,       lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

# =================================================================================================
# ROLES
# =================================================================================================
# You can define any number of roles, each of which contains any number of machines. Roles might
# include such things as :web, or :app, or :db, defining what the purpose of each machine is. You
# can also specify options that can be used to single out a specific subset of boxes in a
# particular role, like :primary => true.

task :production do
  role :web, "72.46.233.151:7004" # merb_background [mongrel] [], call_player [mongrel] [], api [mongrel] [], gts [mongrel] [], jobs [mongrel] []
  role :app, "72.46.233.151:7004", :mongrel => true
  role :db , "72.46.233.151:7004", :primary => true
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end
task :staging do
  role :web, "72.46.233.145:7000" # g5searchmarketing [mongrel] [g5search-db-master], merb_background [mongrel] [], call_player [mongrel] [], api [mongrel] [], gts [mongrel] [], jobs [mongrel] []
  role :app, "72.46.233.145:7000", :mongrel => true
  role :db , "72.46.233.145:7000", :primary => true
  set :rails_env, "staging"
  set :environment_database, defer { staging_database }
  set :environment_dbhost, defer { staging_dbhost }
end

# Do not change below unless you know what you are doing!
after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"