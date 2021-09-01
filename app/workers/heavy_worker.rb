# frozen_string_literal: true

class HeavyWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'heavy'

  def perform(timer)
    sleep timer
  end
end
