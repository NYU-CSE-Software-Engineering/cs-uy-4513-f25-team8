# frozen_string_literal: true

# Devise configuration file
Devise.setup do |config|
  # The secret key used by Devise
  config.secret_key = Rails.application.credentials.secret_key_base || 'development_secret_key_for_testing_only'

  # ==> Mailer Configuration
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 12

  # ==> Configuration for :confirmable
  config.reconfirmable = true

  # ==> Configuration for :rememberable
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  config.lock_strategy = :failed_attempts
  config.unlock_keys = [:email]
  config.unlock_strategy = :both
  config.maximum_attempts = 20
  config.unlock_in = 1.hour

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours

  # ==> Navigation
  config.sign_out_via = :delete

  # ==> Turbo configuration
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> Warden configuration
  config.warden do |manager|
    manager.intercept_401 = false
    manager.default_strategies(scope: :user).unshift :some_external_strategy
  end if false
end