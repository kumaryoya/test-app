# frozen_string_literal: true

100.times do |user_index|
  login_id = "login_id#{user_index + 1}"
  user = User.find_or_create_by(login_id: login_id) do |u|
    u.password = 'password'
    u.password_confirmation = 'password'
  end

  10.times do |post_index|
    post_number = (user_index * 10) + post_index + 1
    Post.create!(
      user_id: user.id,
      title: "title_#{post_number}",
      content: "content_#{post_number}"
    )
  end
end
