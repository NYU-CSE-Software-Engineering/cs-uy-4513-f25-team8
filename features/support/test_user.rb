World(Module.new {
  def sign_in_for_test(user)
    ApplicationController.class_eval do
      define_method(:current_user) { user }
    end
  end
})
