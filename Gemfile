source 'http://rubygems.org'

gem 'rails',          '3.1.1'

gem 'haml',           '~> 3.1.3'
gem 'settingslogic',  '~> 2.0.6'
gem 'redis',          '~> 2.2.2'
gem 'redis-store',    '~> 1.0.0.rc1'
gem "SystemTimer",    "~> 1.2"
gem 'thin',           '~> 1.2.11'
gem 'unicorn',        '~> 4.1.1'
gem 'eycap',          ">= 0.5.22"

gem 'therubyracer',   '~> 0.9.4', :groups => [:staging, :production]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.4"
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails',   "~> 1.0.14"

group :development do
  gem 'capistrano',     "~> 2.8.0"
end

group :test do
  gem 'turn', :require => false
  gem 'rspec-rails',              '~> 2.6.1'
  gem 'guard-rspec',              '>= 0.4.3'
  gem 'guard-spork',              '>= 0.2.1'
  gem 'capybara-webkit',          '>= 0.6.1'
end

unless ENV["TRAVIS"]
  #gem 'ruby-debug19', :require => 'ruby-debug', :group => [:developmen, :test]

  group :test do
    gem 'rb-fsevent',               '>= 0.4.3'
    gem 'growl',                    '>= 1.0.3'
    gem "spork",                    '>= 0.9.0.rc9'
  end
end

