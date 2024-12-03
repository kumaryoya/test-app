# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # All available queries
    field :user_post_counts, [Types::UserType], null: false, description: 'Fetch users and their post counts'
    field :users, [Types::UserType], null: false, description: 'Fetch all users'

    # Resolver for users
    def users
      User.select(:id, :login_id, :created_at, :updated_at)
    end

    # Resolver for user_post_counts
    def user_post_counts
      User.left_joins(:posts)
          .select('users.id, users.login_id, users.created_at, users.updated_at, COUNT(posts.id) AS posts_count')
          .group('users.id')
    end
  end
end
