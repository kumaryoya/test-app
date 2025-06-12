# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user should have lockable columns' do
    user = users(:one)
    assert_respond_to user, :failed_attempts
    assert_respond_to user, :unlock_token
    assert_respond_to user, :locked_at
  end

  test 'new user should have zero failed attempts' do
    user = users(:one)
    assert_equal 0, user.failed_attempts
  end

  test 'user should not be locked initially' do
    user = users(:one)
    assert_not user.access_locked?
  end

  test 'user should be locked after maximum attempts' do
    user = users(:locked_user)
    assert user.access_locked?
  end

  test 'locked user should unlock after unlock time' do
    user = users(:locked_user)
    # Update locked_at to be more than 1 hour ago
    user.update(locked_at: 2.hours.ago)
    
    # Should be unlocked since more than 1 hour has passed
    assert_not user.access_locked?
  end

  test 'locked user should remain locked within unlock time' do
    user = users(:locked_user)
    # locked_at is set to 30 minutes ago in fixture
    
    # Should still be locked since less than 1 hour has passed
    assert user.access_locked?
  end
end