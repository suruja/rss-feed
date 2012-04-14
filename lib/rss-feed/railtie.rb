require "rss-feed"
require "rails"

module Rss
  module Feed
    class Railtie < Rails::Railtie
      rake_tasks do
        require "tasks/rss-feed"
      end
    end
  end
end
