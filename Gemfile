source 'http://rubygems.org'

gem 'rails',          '3.2.20'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3', :require => 'uglifier'
end

gem 'haml',           '~> 4.0.5'
gem 'settingslogic',  '~> 2.0.6'
gem 'redis',          '~> 2.2.2'
gem 'redis-store',    '~> 1.0.0.rc1'
gem 'unicorn',        '~> 4.1.1'
gem 'redis_reload', git: 'git@github.com:g5search/redis_reload.git'

gem 'therubyracer', :groups => [:staging, :production]

group :development do
  gem "capistrano", "~> 2.14.1"
  gem "capistrano-maintenance", :require => false
  gem "eycap", " ~> 0.6.11", :require => false
end

group :test do
  gem 'turn', :require => false
  gem 'rspec-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'fakeredis'
end

unless ENV["TRAVIS"]
  #gem 'ruby-debug19', :require => 'ruby-debug', :group => [:development, :test]

  group :test do
    gem 'rb-fsevent',               '0.9.2'
    gem 'growl',                    '>= 1.0.3'
    gem "spork",                    '>= 0.9.0.rc9'
  end
end
