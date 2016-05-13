require 'open-uri'

namespace :scrape do
  desc 'Scrape Tarheel Trailblazers Website'
  task tarheel: :environment do

    # Keep a list of trails we've processed. Trailblazers website maintainers
    # sometimes don't remove the old status, resulting in duplicate notifications.
    # The first instance of each trail name in the list wins.
    processed_trail_names = []

    doc     = Nokogiri::HTML(open('http://www.tarheeltrailblazers.com/'))
    doc.xpath('//strong').each do |strong|

      open_or_closed = if strong.text =~ /open/i
        'open'
      elsif strong.text =~ /closed/i
        'closed'
      end

      if open_or_closed
        trail_name = strong.parent.parent.parent.parent.parent.parent.previous_element.css('b').text
        #                     font     td     tr  table     td     tr               tr

        trail = Trail.find_by_name(trail_name)

        if trail && trail.status != open_or_closed && !processed_trail_names.include?(trail_name)
          puts "#{trail.name} status changed from #{trail.status} to #{open_or_closed}"
          trail.status = open_or_closed
          trail.status_updated_at = DateTime.now
          trail.save
        end
      end

      processed_trail_names << trail_name
    end
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
      when /are open|is open/i
        'open'
      when /are closed|is closed/i
        'closed'
    end

    if status
      usnwc_trail = Trail.find_by_name('USNWC Trails')

      # Uncomment to always change status to debug
      #status = usnwc_trail.status == 'open' ? 'closed' : 'open'

      if status && usnwc_trail && usnwc_trail.status != status
        puts "USNWC trail status changed from #{usnwc_trail.status} to #{status}"
        usnwc_trail.status = status
        usnwc_trail.status_updated_at = DateTime.now
        usnwc_trail.save
      else
        puts "USNWC trail status did not change."
      end

    else
      puts "The last USNWC tweet was not related to open or closed trails. Tweet text was '#{last_tweet.text}'."
    end
  end

end
