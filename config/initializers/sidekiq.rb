require 'sidekiq/web'

# Sidekiq.configure_server do |config|
#   config.redis = { url: "#{Settings.redis.url}/#{Settings.redis.sidekiq_db}", namespace: Settings.redis.sidekiq_namespace }
#   config.server_middleware do |chain|
#     chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 4
#   end
# end

# Sidekiq.configure_server do |config|
#   config.redis = { url: "redis://127.0.0.1:6379/1", namespace: "development" }
#   config.server_middleware do |chain|
#     chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 4
#   end
# end
#
#
# Sidekiq.configure_client do |config|
#   config.redis = { url: "redis://127.0.0.1:6379/1", namespace: "development"  }
# end
#
#


# Sidekiq.configure_client do |config|
#   config.redis = { url: "#{Settings.redis.url}/#{Settings.redis.sidekiq_db}", namespace: Settings.redis.sidekiq_namespace }
# end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }
end