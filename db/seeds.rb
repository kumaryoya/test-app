# frozen_string_literal: true

10.times do |user_index|
  login_id = "login_id#{user_index + 1}"
  user = User.find_or_create_by(login_id: login_id) do |u|
    u.name = Faker::Name.name
    u.email = Faker::Internet.email
    u.age = rand(0..200)
    u.password = 'password'
    u.password_confirmation = 'password'
  end

  10.times do |post_index|
    Post.create!(
      user_id: user.id,
      title: "ユーザー#{user_index + 1}の投稿#{post_index + 1}のタイトル",
      content: "ユーザー#{user_index + 1}の投稿#{post_index + 1}の内容"
    )
  end
end
