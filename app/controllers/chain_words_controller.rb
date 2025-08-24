# frozen_string_literal: true

class ChainWordsController < ApplicationController
  def index
    @chain_words = ChainWord.includes(:user).order(id: :desc)
    @chain_word = current_user.chain_words.new
  end

  def create
    @chain_word = current_user.chain_words.new(chain_word_params)

    if @chain_word.save
      ActionCable.server.broadcast('chain_word', {
                                     action: 'create',
                                     chain_word: {
                                       word: @chain_word.word,
                                       user_name: @chain_word.user.name
                                     }
                                   })
      redirect_to chain_words_path, notice: 'ChainWord was successfully created.'
    else
      @chain_words = ChainWord.includes(:user).order(id: :desc)
      render :index
    end
  end

  private

  def chain_word_params
    params.require(:chain_word).permit(:word)
  end
end
