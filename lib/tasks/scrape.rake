require 'open-uri'

namespace :scrape do
  desc 'Scrape Tarheel Trailblazers Website'
  task tarheel: :environment do
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

        if trail && trail.status != open_or_closed
          puts "#{trail.name} status changed from #{trail.status} to #{open_or_closed}"
          trail.update_attribute(:status, open_or_closed)
        end
      end
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
      when /are open/i
        'open'
      when /are closed/i
        'closed'
    end

    if status
      usnwc_trail = Trail.find_by_name('USNWC Trails')

      status = usnwc_trail.status == 'open' ? 'closed' : 'open'

      if status && usnwc_trail && usnwc_trail.status != status
        puts "USNWC trail status changed from #{usnwc_trail.status} to #{status}"
        usnwc_trail.update(status: status)
      else
        puts "USNWC trail status did not change."
      end

    else
      puts "The last USNWC tweet was not related to open or closed trails. Tweet text was '#{last_tweet.text}'."
    end
  end

end
