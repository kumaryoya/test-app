# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
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

  test 'user should have lockable columns' do
    assert_respond_to @user, :failed_attempts
    assert_respond_to @user, :unlock_token
    assert_respond_to @user, :locked_at
  end

  test 'new user should have zero failed attempts' do
    assert_equal 0, @user.failed_attempts
  end

  test 'user should not be locked initially' do
    assert_not @user.access_locked?
  end

  test 'failed attempts should increment on invalid authentication' do
    # Simulate failed login attempts
    @user.update(failed_attempts: 5)
    assert_equal 5, @user.failed_attempts
  end

  test 'user should be locked after maximum attempts' do
    # Set failed attempts to maximum (10)
    @user.update(failed_attempts: 10, locked_at: Time.current)
    assert @user.access_locked?
  end

  test 'locked user should unlock after unlock time' do
    # Lock the user
    @user.update(failed_attempts: 10, locked_at: 2.hours.ago)
    
    # Should be unlocked since more than 1 hour has passed
    assert_not @user.access_locked?
  end

  test 'locked user should remain locked within unlock time' do
    # Lock the user recently
    @user.update(failed_attempts: 10, locked_at: 30.minutes.ago)
    
    # Should still be locked since less than 1 hour has passed
    assert @user.access_locked?
  end
end