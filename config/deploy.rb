# For complete deployment instructions, see the following support guide:
# http://www.engineyard.com/support/guides/deploying_your_application_with_capistrano

require "eycap/recipes"
require "bundler/capistrano"

# Servers
DEMO    = "72.46.233.145:7000"
STAGING = "72.46.233.146:7000"
PROD1   = "72.46.233.151:7002"
PROD2   = "72.46.233.151:7003"
UTIL1   = "72.46.233.151:7004"
API     = "72.46.233.109:7000"
URANUS  = "66.39.184.38"
JOBS    = "72.46.233.109:7001"

# =================================================================================================
# ENGINE YARD REQUIRED VARIABLES
# =================================================================================================
# You must always specify the application and repository for every recipe. The repository must be
# the URL of the repository you want this recipe to correspond to. The :deploy_to variable must be
# the root of the application.

set :keep_releases,       5
set :application,         "translatable"
set :user,                "g5search"
set :password,            ENV['EY_PASSWORD']
set :deploy_to,           "/data/#{application}"
set :monit_group,         "translatable"
set :runner,              "g5search"
set :repository,          "git@github.com:perryqh/translatable.git"
set :scm,                 :git
set :staging_host_name,     "real-staging.g5search.com"


# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision,       lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

before :deploy, :set_branch
before 'deploy:long', :set_branch

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

task :set_branch do
  unless exists? :branch
    default_tag = fetch(:default_branch) if exists? :default_branch
    default_tag ||= `git tag`.split("\n").last
    tag = Capistrano::CLI.ui.ask "(Tag|Branch|Commit) to deploy [#{default_tag}]: "
    tag = default_tag if tag.empty?
    set( :branch, tag )
    set( :newrelic_revision, tag ) if tag[0,1] == 'v'
  end
end

after 'deploy:update_code' do
  run "cd #{current_path}; rm -rf public/assets/*"
  run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
end

# =================================================================================================
# ROLES
# =================================================================================================
# You can define any number of roles, each of which contains any number of machines. Roles might
# include such things as :web, or :app, or :db, defining what the purpose of each machine is. You
# can also specify options that can be used to single out a specific subset of boxes in a
# particular role, like :primary => true.

task :production do
  role :web, UTIL1 # merb_background [mongrel] [], call_player [mongrel] [], api [mongrel] [], gts [mongrel] [], jobs [mongrel] []
  role :app, UTIL1, :mongrel => true
  set :rails_env, "production"
end

task :staging do
  role :web, STAGING
  role :app, STAGING, :mongrel => true
  set :rails_env, "staging"
end

# Do not change below unless you know what you are doing!
after "deploy", "deploy:cleanup"
# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"
