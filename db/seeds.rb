# frozen_string_literal: true

require 'csv'

def import_csv(model, file_path)
  batch = []
  CSV.foreach(file_path, headers: true) do |row|
    batch << row.to_h
    if batch.size >= 1000
      model.insert_all(batch)
      batch = []
    end
  end
  model.insert_all(batch) if batch.any?
end

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

ChainWord.create!(
  user_id: 1,
  word: "りんご"
)

ChainWord.create!(
  user_id: 2,
  word: "ごりら"
)

ChainWord.create!(
  user_id: 3,
  word: "らっぱ"
)

import_csv(Race, 'db/data/2020_races.csv')
import_csv(RaceEntry, 'db/data/2020_race_entries.csv')
import_csv(RaceResult, 'db/data/2020_race_results.csv')
