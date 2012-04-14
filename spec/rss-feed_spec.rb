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

  it ".get_feed_from" do
    model.get_feed_from(feed_url)
    model.feed_entries.should_not be_empty
  end

  it ".update_from_feed" do
    model.update_from_feed
    model.count.should equal model.feed_entries.count
  end
end
