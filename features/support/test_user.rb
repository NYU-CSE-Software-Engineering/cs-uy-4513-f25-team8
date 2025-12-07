World(Module.new {
  def sign_in_for_test(user)
    # Use Warden test helpers for Devise authentication
    login_as(user, scope: :user)
    
    # Also set up ApplicationController current_user for compatibility
    ApplicationController.class_eval do
      define_method(:current_user) { user }
    end
  end
})
