class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Flash message is set via locale file
      else
        flash.now[:alert] = "Account name is invalid"
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    root_path
  end
end

