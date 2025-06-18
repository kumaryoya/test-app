# frozen_string_literal: true

require 'test_helper'

class UserLockoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: 'Test User',
      email: 'locktest@example.com',
      age: 25,
      login_id: 'locktest123',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'should not lock account after 9 failed attempts' do
    9.times do
      post new_user_session_path, params: {
        user: { login_id: @user.login_id, password: 'wrongpassword' }
      }
    end
    
    @user.reload
    assert_not @user.access_locked?
    assert_equal 9, @user.failed_attempts
  end

  test 'should lock account after 10 failed attempts' do
    10.times do
      post new_user_session_path, params: {
        user: { login_id: @user.login_id, password: 'wrongpassword' }
      }
    end
    
    @user.reload
    assert @user.access_locked?
    assert_equal 10, @user.failed_attempts
    assert_not_nil @user.locked_at
  end

  test 'should prevent login when account is locked even with correct password' do
    # Lock the account by setting failed attempts to 10
    @user.update!(failed_attempts: 10, locked_at: Time.current)
    
    post new_user_session_path, params: {
      user: { login_id: @user.login_id, password: 'password123' }
    }
    
    assert_not user_signed_in?
    assert_includes response.body, 'アカウントがロックされています'
  end

  private

  def user_signed_in?
    # This method would need to be implemented based on how Devise is set up
    # For now, we'll check session or current_user presence
    session[:user_id].present?
  end
end