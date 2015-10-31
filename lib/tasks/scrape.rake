namespace :scrape do
  desc 'Scrape Tarheel Trailblazers Website'
  task tarheel: :environment do
  end

  desc 'Scrape US National Whitewater Center Twitter Status'
  task usnwc: :environment do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN_KEY']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    last_tweet = client.user_timeline('usnwctrails', count: 1, include_rts: false, exclude_replies: true).first

    status = case last_tweet.text
      when /are open/i
        'open'
      when /are closed/i
        'closed'
    end

    if status
      usnwc_trail = Trail.find_by_name('USNWC Trails')

      if status && usnwc_trail && usnwc_trail.status != status
        puts "USNWC trail status changed from #{usnwc_trail.status} to #{status}"
        usnwc_trail.update(status: status, status_date: last_tweet.created_at)
      else
        puts "USNWC trail status did not change."
      end
    else
      puts 'The last USNWC tweet was not related to open or closed trails.'
    end
  end

end
