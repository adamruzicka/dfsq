namespace :dynflow do
  def dynflow_persistence
    @persistence ||= begin
                       config = Dynflow::Rails::Configuration.new
                       config.db_pool_size = 1 # To prevent automatic detection
                       config.send(:initialize_persistence, nil, :migrate => false)
                     end
  end

  task :migrate => :environment do
    dynflow_persistence.migrate_db
  end
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["dynflow:migrate"].invoke
end
