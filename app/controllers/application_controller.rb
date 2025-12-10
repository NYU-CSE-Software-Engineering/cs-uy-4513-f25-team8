class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Devise: permit extra parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    extra_params = [
      :username,
      :role,
      :security_question_1,
      :security_question_2,
      :security_answer_1,
      :security_answer_2
    ]
    # Permit custom fields for sign_up and account_update
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_params)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_params)
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
