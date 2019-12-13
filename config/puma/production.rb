require "puma_worker_killer"

environment "production"

app_path = File.expand_path("../..", __dir__)

threads 5, 5
workers 3
preload_app!

pidfile "#{app_path}/tmp/pids/puma.pid"
# stdout_redirect "#{app_path}/log/puma.stdout.log", "#{app_path}/log/puma.stderr.log", true

plugin :tmp_restart

before_fork do
  PumaWorkerKiller.config do |config|
    config.ram           = 1024 # mb
    config.frequency     = 5 * 60 # per 5minute
    config.percent_usage = 0.9 # 90%

    config.rolling_restart_frequency = 24 * 3600 # per 1day
    config.reaper_status_logs = true
  end
  PumaWorkerKiller.start
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

