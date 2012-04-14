require "feedzirra"
require "rss-feed/railtie" if defined?(Rails)

module Rss
  module Feed

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def feed_entries
        @feed ? @feed.entries : []
      end

      def subscribes_to(feed_url)
        @feed_url = feed_url
      end

      def feed_url
        @feed_url
      end

      def get_feed
        Feedzirra::Feed.fetch_and_parse(@feed_url).tap do |feed|
          @feed = feed != 0 ? feed : []
        end
      end

      def update_from_feed
        get_feed
        feed_entries.each do |entry|
          entry.sanitize!
          entry_attributes = entry.as_json.inject({}) do |mem, (key, value)|
            mem[key.to_sym] = value; mem
          end
          self.find_or_create_by entry_attributes
        end
      end
    end
  end
end
