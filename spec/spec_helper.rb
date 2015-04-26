require 'rspec/expectations'
require 'chefspec'
require 'chefspec/server'
require 'chefspec/berkshelf'
require 'chefspec/deprecations'
require_relative 'support/matchers'

port = Random.new.rand(8890..8900)
puts "Using randomized chefzero port: #{port}"

server = ChefZero::Server.new(port: port)
server.start_background

at_exit do
  server.stop if server.running?
end

RSpec.configure do |config|
  # Specify the Chef log_level (default: :warn)
  config.log_level = :fatal
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
