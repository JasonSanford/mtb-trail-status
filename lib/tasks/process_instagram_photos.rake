desc 'Process Instagram photos'
task process_instagram_photos: :environment do
  InstagramPhoto.where(processed: false).each do |photo|
    photo.process!
  end
end
