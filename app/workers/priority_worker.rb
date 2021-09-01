# frozen_string_literal: true

class PriorityWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'priority'

  def perform(timer)
    sleep timer
  end
end
