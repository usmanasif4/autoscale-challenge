# frozen_string_literal: true

namespace :autoscale do
  desc 'Intializing jobs'
  task create_and_enqueue_jobs: :environment do
    (1..ENV['ENQUEUE_MAX_JOBS'].to_i).each do |elem|
      case rand(3)
      when 0
        puts "inserting priority job #{elem}"
        PriorityWorker.perform_async(rand(1..10))
      when 1
        puts "inserting misc job #{elem}"
        MiscWorker.perform_async(rand(11..20))
      when 2
        puts "inserting higher job #{elem}"
        HeavyWorker.perform_async(rand(21..1200))
      end
    end
  end

  desc 'Scale server instances'
  task scale_servers: :environment do
    AwsScalarMetrics.new.launch_autoscale_group_instances
  end

  desc 'Terminate the idle instances'
  task terminate_idle_instances: :environment do
    AwsScalarMetrics.new.terminate_autoscale_group_instance
  end
end
