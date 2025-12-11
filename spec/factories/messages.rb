FactoryBot.define do
  factory :message do
    conversation
    # Default to the conversation's owner sending the message
    sender { conversation.owner } 
    body { "Hello world" }
  end
end
