namespace :rss do
  namespace :feed do
    desc 'get and store new feed entries for the models that subscribed to a RSS feed url.'
    task :update => :environment do
      Dir[Rails.root.to_s + '/app/models/**/*.rb'].each { |file| load file }
      models = ObjectSpace.each_object(::Class).select do |klass|
        klass.include?(Rss::Feed) and klass.feed_url
      end
      models.each do |model|
        model.update_from_feed
      end
    end
  end
end
