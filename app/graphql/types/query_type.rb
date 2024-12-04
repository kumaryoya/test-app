# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false
    field :user_post_counts, [Types::UserType], null: false

    def users
      User.select(:id, :name, :age)
    end

    def user_post_counts
      User.left_joins(:posts)
          .select('users.id, users.name, COUNT(posts.id) AS posts_count')
          .group('users.id')
    end
  end
end
