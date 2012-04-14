namespace :rss do
  namespace :feed do
    desc 'get and store new feed entries for the models that subscribed to a RSS feed url.'
    task :update do
      Dir[Rails.root.to_s + '/app/models/**/*.rb'].each { |file| require file }
      models = ObjectSpace.each_object(::Class).select do |klass|
        klass.include?(Rss::Feed) and not klass.feed_url.empty?
      end
      models.each do |model|
        model.update_from_feed
      end
    end
  end
end
