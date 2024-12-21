# frozen_string_literal: true

class Article < ApplicationRecord
  encrypts :body

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
end
