require "feedzirra"

module Rss
  module Crons
    def self.get_feed_from(feed_url)
      @feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    end

    def self.update_from_feed
      @feed.new_entries.tap do |feed_new_entries|
        record = self.new
        feed_new_entries.each do |entry|
          entry.to_hash.each do |key, value|
            self[key.to_sym] = value.sanitize
          end
          record.save
        end
      end
    end
  end
end
