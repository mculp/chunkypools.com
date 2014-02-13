rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind  "unix:///data/apps/chunkypools.com/shared/tmp/puma/chunkypools.com-puma.sock"
pidfile "/data/apps/chunkypools.com/current/tmp/puma/pid"
state_path "/data/apps/chunkypools.com/current/tmp/puma/state"

activate_control_app
