# frozen_string_literal: true

class ChainWordChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chain_word'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
