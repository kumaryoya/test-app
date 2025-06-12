# frozen_string_literal: true

require 'test_helper'

class UserLockableIntegrationTest < ActionDispatch::IntegrationTest
  test 'user can login with correct credentials' do
    user = users(:one)
    
    post user_session_path, params: {
      user: { login_id: user.login_id, password: 'password123' }
    }

    assert_redirected_to root_path
  end

  test 'failed login increments failed attempts' do
    user = users(:one)
    
    post user_session_path, params: {
      user: { login_id: user.login_id, password: 'wrongpassword' }
    }

    user.reload
    assert_equal 1, user.failed_attempts
  end

  test 'locked user cannot login even with correct password' do
    user = users(:locked_user)

    # Try to login with correct password
    post user_session_path, params: {
      user: { login_id: user.login_id, password: 'password123' }
    }

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_match(/locked/i, response.body)
  end

  test 'successful login resets failed attempts' do
    user = users(:two) # Has 5 failed attempts
    
    post user_session_path, params: {
      user: { login_id: user.login_id, password: 'password123' }
    }

    user.reload
    assert_equal 0, user.failed_attempts
    assert_redirected_to root_path
  end
end