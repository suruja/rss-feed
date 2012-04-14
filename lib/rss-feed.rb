require "feedzirra"

module Rss
  module Feed

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def feed_entries
        @feed ? @feed.entries : []
      end

      def get_feed_from(feed_url)
        Feedzirra::Feed.fetch_and_parse(feed_url).tap do |feed|
          @feed = feed != 0 ? feed : []
        end
      end

      def update_from_feed
        feed_entries.each do |entry|
          entry.sanitize!
          entry_attributes = entry.to_a.inject({}) do |memo, (key, value)|
            memo[key.to_sym] = value; memo
          end
          self.find_or_create_by entry_attributes
        end
      end
    end
  end
end
