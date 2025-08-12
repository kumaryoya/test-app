# frozen_string_literal: true

class ChainWord < ApplicationRecord
  belongs_to :user

  validates :word, presence: true, uniqueness: true, length: { maximum: 255 },
                   format: { with: /\A[\p{Hiragana}]+\z/, message: 'はひらがなのみで入力してください' }

  validate :chain_word_rule

  private

  def chain_word_rule
    return if word.blank?

    last_chain_word = ChainWord.order(:created_at).last
    return if last_chain_word.nil?

    last_word = last_chain_word.word
    return if last_word.blank?

    last_char = last_word.chars.last
    first_char = word.chars.first

    return if last_char == first_char

    errors.add(:word, "「#{last_char}」で始まる単語を入力してください")
  end
end
