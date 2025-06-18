# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Test User',
      email: 'test@example.com',
      age: 25,
      login_id: 'testuser123',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'should have lockable attributes' do
    assert_respond_to @user, :failed_attempts
    assert_respond_to @user, :locked_at
    assert_respond_to @user, :unlock_token
  end

  test 'should have default failed_attempts value' do
    @user.save!
    assert_equal 0, @user.failed_attempts
  end

  test 'should respond to access_locked?' do
    assert_respond_to @user, :access_locked?
  end

  test 'should respond to increment_failed_attempts' do
    assert_respond_to @user, :increment_failed_attempts
  end

  test 'should respond to lock_access!' do
    assert_respond_to @user, :lock_access!
  end

  test 'should respond to unlock_access!' do
    assert_respond_to @user, :unlock_access!
  end
end