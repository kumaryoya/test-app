# frozen_string_literal: true

require 'test_helper'

class UserLockableIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: 'Test User',
      email: 'integration@example.com',
      age: 25,
      login_id: 'integrationuser',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'user gets locked after maximum failed attempts' do
    # Simulate 10 failed login attempts
    10.times do
      post user_session_path, params: {
        user: { login_id: 'integrationuser', password: 'wrongpassword' }
      }
    end

    @user.reload
    assert_equal 10, @user.failed_attempts
    assert @user.access_locked?
  end

  test 'locked user receives proper error message' do
    # Lock the user first
    @user.lock_access!
    
    # Try to login
    post user_session_path, params: {
      user: { login_id: 'integrationuser', password: 'password123' }
    }

    assert_redirected_to new_user_session_path
    assert_match(/アカウントはロックされています/, flash[:alert]) if I18n.locale == :ja
  end

  test 'successful login resets failed attempts' do
    # Set some failed attempts
    @user.update!(failed_attempts: 5)
    
    # Successful login
    post user_session_path, params: {
      user: { login_id: 'integrationuser', password: 'password123' }
    }

    @user.reload
    assert_equal 0, @user.failed_attempts
    assert_redirected_to root_path
  end
end