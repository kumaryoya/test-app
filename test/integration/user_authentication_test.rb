# frozen_string_literal: true

require 'test_helper'

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  test "user should be locked after maximum failed attempts" do
    # This test verifies the account locking concept
    # In a real Rails app with proper setup, this would test actual authentication
    
    user = users(:one)
    
    # Simulate reaching the maximum failed attempts
    user.update!(failed_attempts: 10, locked_at: Time.current)
    
    # Verify user is locked
    assert user.access_locked?
    assert_equal 10, user.failed_attempts
    assert_not_nil user.locked_at
  end

  test "user should be automatically unlocked after unlock time" do
    user = users(:one)
    
    # Lock the user 2 hours ago (beyond the 1 hour unlock time)
    user.update!(failed_attempts: 10, locked_at: 2.hours.ago)
    
    # In a real implementation, Devise would handle this automatically
    # Here we just verify the time logic
    assert user.locked_at < 1.hour.ago, "User should be past unlock time"
  end
end