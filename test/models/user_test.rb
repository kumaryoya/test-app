# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should have lockable attributes' do
    user = users(:test_user)
    assert_respond_to user, :failed_attempts
    assert_respond_to user, :locked_at
    assert_respond_to user, :unlock_token
  end

  test 'should have default failed_attempts of 0' do
    user = User.create!(
      name: 'New User',
      email: 'newuser@example.com',
      age: 25,
      login_id: 'new_user',
      password: 'password123',
      password_confirmation: 'password123'
    )
    assert_equal 0, user.failed_attempts
  end

  test 'should respond to lockable methods' do
    user = users(:test_user)
    assert_respond_to user, :lock_access!
    assert_respond_to user, :unlock_access!
    assert_respond_to user, :access_locked?
  end

  test 'should lock account manually' do
    user = users(:test_user)
    user.lock_access!

    assert user.access_locked?
    assert_not_nil user.locked_at
  end

  test 'should unlock account manually' do
    user = users(:locked_user)
    user.unlock_access!

    assert_not user.access_locked?
    assert_nil user.locked_at
    assert_equal 0, user.failed_attempts
  end
end
