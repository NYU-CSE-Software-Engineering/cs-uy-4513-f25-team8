Given("the following users exist:") do |table|
  table.hashes.each do |user_data|
    User.create!(user_data)
  end
end
