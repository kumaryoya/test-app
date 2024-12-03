# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_user!

      # http://localhost:3000/api/v1/users
      def index
        users = User.select(:id, :name, :age)
        render json: { status: 'success', data: users }, status: :ok
      end

      # http://localhost:3000/api/v1/users/count_posts
      def count_posts
        user_post_counts = User.left_joins(:posts)
                               .select('users.id, users.name, COUNT(posts.id) AS posts_count')
                               .group('users.id')

        data = user_post_counts.map do |record|
          {
            id: record.id, name: record.name,
            posts_count: record.posts_count
          }
        end

        render json: { status: 'success', data: data }, status: :ok
      end
    end
  end
end
