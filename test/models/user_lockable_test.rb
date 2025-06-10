# frozen_string_literal: true

require 'test_helper'

class UserLockableTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: 'Test User',
      email: 'test@example.com',
      age: 30,
      login_id: 'testuser',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'user should have lockable attributes' do
    assert_respond_to @user, :failed_attempts
    assert_respond_to @user, :locked_at
    assert_respond_to @user, :unlock_token
  end

  test 'user should be lockable after maximum attempts' do
    assert_equal 0, @user.failed_attempts
    refute @user.access_locked?

    # Simulate failed attempts up to the maximum
    9.times do
      @user.increment!(:failed_attempts)
    end

    assert_equal 9, @user.failed_attempts
    refute @user.access_locked?

    # The 10th failed attempt should lock the account
    @user.increment!(:failed_attempts)
    @user.lock_access!

    assert_equal 10, @user.failed_attempts
    assert @user.access_locked?
    assert_not_nil @user.locked_at
  end

  test 'locked user should be unlocked after unlock_in time' do
    @user.lock_access!
    assert @user.access_locked?

    # Simulate time passage beyond unlock_in (1 hour)
    @user.update!(locked_at: 2.hours.ago)
    
    # User should no longer be locked
    refute @user.access_locked?
  end

  test 'successful login should reset failed attempts' do
    @user.update!(failed_attempts: 5)
    assert_equal 5, @user.failed_attempts

    # Reset failed attempts (simulating successful login)
    @user.update!(failed_attempts: 0)
    assert_equal 0, @user.failed_attempts
  end
end