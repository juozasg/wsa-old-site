# Config from http://unicorn.bogomips.org/examples/unicorn.conf.rb

# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

require 'config/app.rb'

app_name = @app_host
app_path = "/var/www/#{app_name}/current"

worker_processes 4

working_directory app_path

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/#{app_name}.unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 60

# feel free to point this anywhere accessible on the filesystem
pid "/var/run/unicorn.pid"

stderr_path "/var/log/unicorn/#{app_name}.stderr.log"
stdout_path "/var/log/unicorn/#{app_name}.stdout.log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end