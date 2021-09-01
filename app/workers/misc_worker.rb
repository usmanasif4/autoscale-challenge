# frozen_string_literal: true

class MiscWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'misc'

  def perform(timer)
    sleep timer
  end
end
