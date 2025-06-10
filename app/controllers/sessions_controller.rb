# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  include ActionView::Helpers::DateHelper
  
  skip_before_action :authenticate_user!, only: %i[new create]

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  def after_sign_in_attempt_failed
    user = User.find_by(login_id: params[:user][:login_id])
    
    if user && user.failed_attempts >= Devise.maximum_attempts - 1
      flash[:alert] = I18n.t('devise.failure.last_attempt')
    end
  end

  def respond_to_on_lock
    flash[:alert] = I18n.t('devise.failure.locked', unlock_in: distance_of_time_in_words(Time.now, user.locked_at + Devise.unlock_in))
    redirect_to new_user_session_path
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
