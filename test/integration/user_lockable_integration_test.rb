# frozen_string_literal: true

require 'test_helper'

class UserLockableIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: 'Test User',
      email: 'test@example.com',
      login_id: 'testuser',
      age: 25,
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'user account gets locked after 10 failed login attempts' do
    # Attempt login 10 times with wrong password
    10.times do
      post user_session_path, params: {
        user: { login_id: @user.login_id, password: 'wrongpassword' }
      }
    end

    @user.reload
    assert_equal 10, @user.failed_attempts
    assert @user.access_locked?
  end

  test 'locked user cannot login even with correct password' do
    # Lock the user
    @user.update(failed_attempts: 10, locked_at: Time.current)

    # Try to login with correct password
    post user_session_path, params: {
      user: { login_id: @user.login_id, password: 'password123' }
    }

    assert_redirected_to new_user_session_path
    assert flash[:alert].present?
  end

  test 'failed attempts reset after successful login' do
    # Set some failed attempts
    @user.update(failed_attempts: 5)

    # Login successfully
    post user_session_path, params: {
      user: { login_id: @user.login_id, password: 'password123' }
    }

    @user.reload
    assert_equal 0, @user.failed_attempts
  end

  test 'user can login after lock expires' do
    # Lock the user 2 hours ago (beyond the 1-hour limit)
    @user.update(failed_attempts: 10, locked_at: 2.hours.ago)

    # Should be able to login now
    post user_session_path, params: {
      user: { login_id: @user.login_id, password: 'password123' }
    }

    # Should not be redirected back to login form
    assert_not_equal new_user_session_path, path
  end
end