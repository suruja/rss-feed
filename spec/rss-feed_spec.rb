require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rss::Feed do

  let(:model) do
    Newspaper
  end

  let(:feed_url) do
    "https://news.google.fr/news/feeds?output=rss"
  end

  before do
    model.destroy_all
  end

  describe ".get_feed_from" do

    context "when a valid feed url is provided" do
      it "gets feed entries from the feed url" do
        model.get_feed_from(feed_url)
        model.feed_entries.should_not be_empty
      end
    end

    context "when an invalid or empty feed url is provided" do
      it "does not get anything" do
        model.get_feed_from('')
        model.feed_entries.should be_empty
      end
    end
  end

  describe ".update_from_feed" do

    it "insert new documents for each unexistant feed entry" do
      model.update_from_feed
      model.count.should equal model.feed_entries.count

      model.update_from_feed
      model.count.should equal model.feed_entries.count
    end
  end
end
