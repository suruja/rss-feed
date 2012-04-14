require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rss::Feed do

  let(:model) do
    Newspaper
  end

  let(:feed_url) do
    "http://www.groupe-alpha.com/fr/toute-actu/depeches-afp.html?feed=rss"
  end

  before do
    model.destroy_all
  end

  describe ".get_subscribes_to" do

    context "when a valid feed url is provided" do
      it "gets feed entries from the feed url" do
        model.subscribes_to feed_url
        model.get_feed
        model.feed_entries.should_not be_empty
      end
    end

    context "when an invalid or empty feed url is provided" do
      it "does not get anything" do
        model.subscribes_to 'invalid_url'
        model.get_feed
        model.feed_entries.should be_empty
      end
    end
  end

  describe ".update_from_feed" do

    before do
      model.subscribes_to feed_url
      model.get_feed
    end

    it "inserts as many documents as feed entries first" do
      model.update_from_feed
      model.count.should be > 0
      model.count.should equal model.feed_entries.count
    end

    it "inserts new documents for each unexistant feed entry then" do
      model.update_from_feed
      model.count.should equal model.feed_entries.count
    end
  end
end
