# frozen_string_literal: true

class ChainWord < ApplicationRecord
  belongs_to :user

  validates :word, presence: true, uniqueness: true, length: { maximum: 255 },
                   format: { with: /\A[\p{Hiragana}]+\z/, message: 'はひらがなのみで入力してください' }
end
