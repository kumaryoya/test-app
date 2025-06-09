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

  def after_sign_in_attempt_failed
    user = User.find_by(login_id: params[:user][:login_id])
    return unless user && user.failed_attempts >= Devise.maximum_attempts - 1

    flash[:alert] = I18n.t('devise.failure.last_attempt')
  end

  def respond_to_on_lock
    unlock_time = distance_of_time_in_words(Time.current, resource.locked_at + Devise.unlock_in)
    flash[:alert] = I18n.t('devise.failure.locked', unlock_in: unlock_time)
    redirect_to new_user_session_path
  end
end
