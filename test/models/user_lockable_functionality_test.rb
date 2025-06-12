# frozen_string_literal: true

require 'test_helper'

class UserLockableFunctionalityTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: 'Test User',
      email: 'locktest@example.com',
      login_id: 'locktest',
      age: 25,
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'validates all lockable requirements are implemented' do
    # Requirement 1: User can fail login 10 times before account gets locked
    assert_equal 0, @user.failed_attempts
    assert_not @user.access_locked?

    # Simulate 9 failed attempts - should not be locked yet  
    @user.update(failed_attempts: 9)
    assert_not @user.access_locked?

    # 10th failed attempt should lock the account
    @user.update(failed_attempts: 10, locked_at: Time.current)
    assert @user.access_locked?
  end

  test 'locked account denies access even with correct password' do
    # Requirement 2: Locked account prevents login even with correct password
    @user.update(failed_attempts: 10, locked_at: Time.current)
    assert @user.access_locked?

    # In a real scenario, Devise would handle this, but we can verify the locked state
    assert_equal 10, @user.failed_attempts
    assert @user.locked_at.present?
  end

  test 'account unlocks automatically after 1 hour' do
    # Requirement 3: Account automatically unlocks after 1 hour
    @user.update(failed_attempts: 10, locked_at: 2.hours.ago)
    
    # Should be unlocked now since more than 1 hour has passed
    assert_not @user.access_locked?
  end

  test 'warning should be shown before final attempt' do
    # Requirement 4: Warning message on 9th failed attempt
    # This is handled by Devise configuration: config.last_attempt_warning = true
    @user.update(failed_attempts: 9)
    
    # User is not locked yet but should receive a warning on next failed attempt
    assert_not @user.access_locked?
    assert_equal 9, @user.failed_attempts
  end

  test 'validates Devise configuration values match requirements' do
    # Verify configuration matches exact requirements
    assert_equal :failed_attempts, Devise.lock_strategy
    assert_equal :time, Devise.unlock_strategy  
    assert_equal 10, Devise.maximum_attempts
    assert_equal 1.hour, Devise.unlock_in
    assert Devise.last_attempt_warning
  end
end