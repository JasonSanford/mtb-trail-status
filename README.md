# MTB Trail Status

This is the rails app behind http://mtbtrailstat.us, a mountain bike trail status site and notification service for Charlotte, North Carolina.

## How It Works

This site tracks the status of a number of mountain bike trail systems in the Charlotte, NC area. Statuses are scraped from either the [Tarheel Trailblazers website](http://www.tarheeltrailblazers.com/) and the [US National Whitewater Center trails twitter feed](https://twitter.com/usnwctrails). If the status of any of those trails changes, any users subscribed to those trails are notified by either SMS or email.

Email is handled by [SendGrid](https://sendgrid.com/). SMS is handled by [Twilio](https://www.twilio.com/).

SMS is expensive so this is a paid feature. Payment is handled by [Stripe](https://stripe.com/), which is indistinguishable from magic as far as I can tell.

## Development

Install dependencies. First, you'll need Postgres.

```bash
brew install postgres
```

Then, install the app dependencies.

```bash
bundle install --path=.bundle
bundle exec rake db:setup
```

If all that worked then start up the app.

```bash
bundle exec foreman start -f Procfile.dev
```
