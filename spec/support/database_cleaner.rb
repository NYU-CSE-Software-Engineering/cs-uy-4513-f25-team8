RSpec.configure do |config|
  # reset database before any tests
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # ues transactions so we can rollback
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  # rollback all transactions after each test
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
