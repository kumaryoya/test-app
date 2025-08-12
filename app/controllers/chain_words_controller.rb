# frozen_string_literal: true

class ChainWordsController < ApplicationController
  def index
    @chain_words = ChainWord.includes(:user).order(id: :desc)
    @chain_word = current_user.chain_words.new
  end

  def create
    @chain_word = current_user.chain_words.new(chain_word_params)

    if @chain_word.save
      # WebSocketでリアルタイム更新をブロードキャスト
      ActionCable.server.broadcast('chain_words', {
                                     action: 'create',
                                     chain_word: {
                                       id: @chain_word.id,
                                       word: @chain_word.word,
                                       user_name: @chain_word.user.name,
                                       created_at: @chain_word.created_at
                                     }
                                   })

      respond_to do |format|
        format.html { redirect_to chain_words_path, notice: 'ChainWord was successfully created.' }
        format.json { render json: { status: 'success', message: 'ChainWord was successfully created.' } }
      end
    else
      respond_to do |format|
        format.html do
          @chain_words = ChainWord.includes(:user).order(id: :desc)
          render :index
        end
        format.json { render json: { status: 'error', errors: @chain_word.errors.full_messages } }
      end
    end
  end

  private

  def chain_word_params
    params.require(:chain_word).permit(:word)
  end
end
