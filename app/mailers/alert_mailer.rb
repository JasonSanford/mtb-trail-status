class AlertMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: "MTB Trail Status <info@mtbtrailstat.us>"
  layout 'mailer'

  def trail_alert(alert)
    @alert = alert
    mail(to: alert.user.email, subject: "#{@alert.trail.name} is now #{@alert.trail.status}.")
  end
end
