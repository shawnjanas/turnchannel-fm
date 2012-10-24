worker_processes 3
timeout 30
preload_app true

@resque_pid = nil
@resque_schedule_pid = nil

before_fork do |server, worker|
  @resque_pid ||= spawn("bundle exec rake " + \
  "resque:work QUEUES=*")

  @resque_schedule_pid ||= spawn("bundle exec rake " + \
  "resque:scheduler")
end
