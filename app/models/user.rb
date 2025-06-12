# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :lockable, authentication_keys: [:login_id]

  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :age, presence: true,
                  numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 200 }
  validates :login_id, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { minimum: 8, maximum: 64 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
