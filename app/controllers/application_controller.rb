class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  attr_accessor :test_current_user

  def current_user
    # Use mock login in test environment
    return test_current_user if test_current_user.present?

    # No real login yet → just return nil
    nil
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
