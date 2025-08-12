# frozen_string_literal: true

class ChainWordsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chain_words'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
