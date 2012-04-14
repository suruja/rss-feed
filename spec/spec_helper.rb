$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

MODELS = File.join(File.dirname(__FILE__), "app/models")
SUPPORT = File.join(File.dirname(__FILE__), "support")
$LOAD_PATH.unshift(MODELS)
$LOAD_PATH.unshift(SUPPORT)

require 'rspec'
require 'mongoid'
require 'rss-feed'

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["MONGOID_SPEC_HOST"] ||= "localhost"
ENV["MONGOID_SPEC_PORT"] ||= "27017"

# These are used when creating any connection in the test suite.
HOST = ENV["MONGOID_SPEC_HOST"]
PORT = ENV["MONGOID_SPEC_PORT"]

# Convenience for creating a new logger for debugging.
LOGGER = Logger.new($stdout)

# When testing locally we use the database named mongoid_test. However when
# tests are running in parallel on Travis we need to use different database
# names for each process running since we do not have transactions and want a
# clean slate before each spec run.
def database_id
  ENV["CI"] ? "mongoid_#{Process.pid}" : "mongoid_test"
end

Mongoid.configure do |config|
  database = Mongo::Connection.new(HOST, PORT).db(database_id)
  database.add_user("mongoid", "test")
  config.master = database
  config.logger = nil
end

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  autoload name.camelize.to_sym, name
end

# Require everything in spec/support.
Dir[ File.join(SUPPORT, "*.rb") ].each do |file|
  require File.basename(file)
end

module Rails
  class Application
  end
end

module MyApp
  class Application < Rails::Application
  end
end
