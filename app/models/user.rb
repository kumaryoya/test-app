# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, authentication_keys: [:login_id]

  has_many :posts, dependent: :destroy

  validates :login_id, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { minimum: 8, maximum: 64 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
