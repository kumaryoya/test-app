# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :created_at, String, null: false
    field :id, ID, null: false
    field :login_id, String, null: false
    field :posts_count, Integer, null: true
    field :updated_at, String, null: false
  end
end
