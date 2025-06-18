# frozen_string_literal: true

require 'test_helper'

class UserLockableTest < ActionDispatch::IntegrationTest
  test 'should lock account after 10 failed login attempts' do
    user = users(:test_user)

    10.times do
      post user_session_path, params: {
        user: {
          login_id: user.login_id,
          password: 'wrong_password'
        }
      }
    end

    user.reload
    assert user.access_locked?, 'User should be locked after 10 failed attempts'
  end

  test 'should not allow login when account is locked' do
    user = users(:locked_user)

    post user_session_path, params: {
      user: {
        login_id: user.login_id,
        password: 'password123'
      }
    }

    assert_redirected_to new_user_session_path
  end

  test 'should allow login after unlock time has passed' do
    user = users(:test_user)
    user.lock_access!
    user.update(locked_at: 2.hours.ago)

    post user_session_path, params: {
      user: {
        login_id: user.login_id,
        password: 'password123'
      }
    }

    assert_redirected_to root_path
  end

  test 'should reset failed attempts after successful login' do
    user = users(:test_user)
    user.update(failed_attempts: 5)

    post user_session_path, params: {
      user: {
        login_id: user.login_id,
        password: 'password123'
      }
    }

    user.reload
    assert_equal 0, user.failed_attempts
  end
end
