# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    return if user_signed_in?

    redirect_to new_user_session_path
  end
end
