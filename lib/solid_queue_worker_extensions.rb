module SolidQueueWorkerExtensions
  extend ActiveSupport::Concern

  included do
    set_callback :boot, :before do
      require 'dynflow/executors/solid_queue/core'
      if (queues & ['dynflow_orchestrator', '*']).any?
        # Sidekiq.options[:dynflow_executor] = true
        ::Rails.application.dynflow.executor!
      elsif (queues - ['dynflow_orchestrator']).any?
        ::Rails.application.dynflow.config.remote = true
      end
      puts "before"
      ::Dynflow.process_world = ::Rails.application.dynflow.world
      puts "set world"
      ::Rails.application.dynflow.initialize!
      puts "initialized"
    end
  end
end
