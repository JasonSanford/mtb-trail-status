desc 'Process Instagram photos'
task process_instagram_photos: :environment do
  InstagramPhoto.where(processed: false).each do |photo|
    response = HTTParty.get(photo.oembed_url)
    photo.update(json: response.body, processed: true)
  end
end
