source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'jquery-rails'

# server
gem 'thin'

# database
gem 'mongoid'
gem 'bson_ext'

# background jobs
gem 'resque', '>= 1.18.0', require: 'resque/server'

# template
gem 'haml'

# auth
gem 'devise'
gem 'oa-oauth', require: 'omniauth/oauth'

# models
gem 'kaminari'

# performance enhancements
# gem 'escape_utils'
# gem 'yajl-ruby', require: 'yajl/json_gem'


group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end


group :production do
  gem 'newrelic_rpm'
  gem 'hoptoad_notifier'
end


group :development do
  gem 'haml-rails'            # haml generators and auto config
  gem 'foreman'               # run procfile locally similar to heroku cedar stack
  gem 'heroku'                # deploy to heroku
end


group :development, :test do
  gem 'rspec-rails'
  gem 'ruby-debug19', require: 'ruby-debug'

  # used by guard but commented out so it's not included in the Gemfile.lock for deployment
  # gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
end


group :test do
  gem 'factory_girl'          # not factory_girl_rails due to spork
  gem 'faker'
  gem 'pickle'

  gem 'fakeweb'
  gem 'resque_spec'           # matchers for testing resque enqueueing in rspec and cucumber

  # automation
  gem 'spork', '~> 0.9.0.rc9'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  # gem 'guard-pow'           # reload environment when needed
  # gem 'guard-livereload'    # auto reload browser when view files change

  # acceptance testing
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'database_cleaner'      # reset databases before tests
  gem 'launchy'               # enable capybara save_and_open_page
  # gem 'capybara-firebug'    # enable firebug in capybara sessions
end
