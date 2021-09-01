# frozen_string_literal: true

class AwsScalarMetrics

  def initialize
    unless is_development?
      @client = AWS::AutoScaling::Client.new(region: ENV['AWS_REGION'],
                                             access_key_id: ENV['AWS_ACCESS_KEY_ID_SECRET'],
                                             secret_access_key: ENV['AWS_ACCESS_KEY_SECRET']
                                            )
    end
  end

  def launch_autoscale_group_instances
    ps = Sidekiq::ProcessSet.new
    stats = Sidekiq::Stats.new
    ps.each do |process|
      (1..(stats.queues['priority'].to_f / ENV['THREADS'].to_f).ceil).each do
        if is_development?
          system 'bundle exec sidekiq -c 10 -q priority'
        else
          @client.update_auto_scaling_group({ auto_scaling_group_name: 'priority',  desired_capacity: 10 })
        end
      end
    end
  end

  def terminate_autoscale_group_instance
    ps = Sidekiq::ProcessSet.new
    idle_servers = []
    ps.each do |process|
      idle_servers << process if process['busy'].zero?
    end
    idle_servers.each(&:quiet!)
    idle_servers.each(&:stop!)
  end

  private

  def is_development?
    Rails.env == 'development'
  end
end
