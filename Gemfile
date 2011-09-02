source 'http://rubygems.org'

gem 'rails',          '3.1.0.rc8'

gem 'haml',           '~> 3.1.2'
gem 'settingslogic',  '~> 2.0.6'
gem 'redis',          '~> 2.2.2'
gem "redis-store",    '~> 1.0.0.rc1'

gem 'sqlite3', :group => [:development, :test]
gem 'pg', :group => [:qa, :production]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier',     "~> 1.0.2"
end

gem 'jquery-rails',   "~> 1.0.13"


# To use debugger
#gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'rspec-rails',              '~> 2.6.1'
  gem 'guard-rspec',              '>= 0.4.3'
  gem 'guard-spork',              '>= 0.2.1'
  gem 'rb-fsevent',               '>= 0.4.3'
  gem 'growl',                    '>= 1.0.3'
  gem "spork",                    '>= 0.9.0.rc9'
  gem "database_cleaner",         '>= 0.6.7'
  gem 'capybara',                 :git => 'git://github.com/jnicklas/capybara.git'
end
