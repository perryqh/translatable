source 'http://rubygems.org'

gem 'rails',          '3.1.0'

gem 'haml',           '~> 3.1.2'
gem 'settingslogic',  '~> 2.0.6'
gem 'redis',          '~> 2.2.2'
gem 'redis-store',    '~> 1.0.0.rc1'
gem 'thin',           '~> 1.2.11', :group => [:qa, :production]
#gem 'unicorn',        '~> 4.1.1',  :group => [:development, :staging, :production]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier',     "~> 1.0.3"
end

gem 'jquery-rails',   "~> 1.0.13"

gem 'capistrano',     "~> 2.8.0"
gem 'eycap',         "~> 0.5.20"

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
  gem 'capybara-webkit',          '>= 0.6.1'
end
