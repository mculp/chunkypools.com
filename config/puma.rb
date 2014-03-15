rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind  "unix:/var/run/puma.sock"
pidfile "/tmp/puma/pid"
state_path "/tmp/puma/state"

activate_control_app
