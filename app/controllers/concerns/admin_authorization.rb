module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :ensure_admin
  end

  private

  def ensure_admin
    unless current_user&.role == 'admin'
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end
end

