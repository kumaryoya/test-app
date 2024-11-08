# frozen_string_literal: true

User.find_or_create_by(login_id: 'login_id1') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
