source "https://rubygems.org"

# Core
gem "rails", "~> 8.1.0"
gem "puma", ">= 5.0"
gem "sqlite3", ">= 2.1"
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Windows time zone data
gem "tzinfo-data", platforms: %i[windows jruby]

# Caching / Queues / Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Boot perf
gem "bootsnap", require: false

# Optional deploy/tools
gem "kamal", require: false
gem "thruster", require: false

# Active Storage variants
gem "image_processing", "~> 1.2"

# Authentication
gem "devise", "~> 4.9"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  # System/feature testing
  gem "capybara"
  gem "selenium-webdriver"

  # BDD stack
  gem "rspec-expectations", "~> 3.13"
  gem "cucumber", "~> 10.1"
  gem "cucumber-rails", "~> 4.0", require: false
end
