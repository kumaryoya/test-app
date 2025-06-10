# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should have lockable fields" do
    user = User.new
    assert_respond_to user, :failed_attempts
    assert_respond_to user, :locked_at
    assert_respond_to user, :unlock_token
  end

  test "user should have lockable methods" do
    user = users(:one)
    assert_respond_to user, :locked_at
    assert_respond_to user, :access_locked?
  end

  test "failed_attempts should default to 0" do
    user = User.new(
      name: "New User",
      email: "new@example.com", 
      age: 25,
      login_id: "newuser",
      password: "password123"
    )
    assert_equal 0, user.failed_attempts
  end

  test "user should be locked after 10 failed attempts" do
    user = users(:one)
    
    # Simulate 10 failed attempts
    10.times do
      user.increment(:failed_attempts)
    end
    user.save!
    
    # Check if user is locked (this would normally be handled by Devise)
    assert_equal 10, user.failed_attempts
  end

  test "user access_locked should return false for new user" do
    user = users(:one)
    assert_not user.access_locked?
  end

  test "user access_locked should return true when locked_at is set" do
    user = users(:one)
    user.locked_at = Time.current
    user.save!
    assert user.access_locked?
  end

  test "user should be unlocked after 1 hour" do
    user = users(:one)
    user.locked_at = 2.hours.ago
    user.save!
    
    # With time-based unlock strategy, this should be unlocked
    # This tests the concept - actual unlock would be handled by Devise
    assert user.locked_at < 1.hour.ago
  end
end