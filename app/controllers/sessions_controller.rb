# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: %i[new create]

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
