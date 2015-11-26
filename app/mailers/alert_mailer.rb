class AlertMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: "MTB Trail Status <info@mtbtrailstat.us>"
  layout 'mailer'

  def trail_alert(alert)
    @alert    = alert
    is_or_are = @alert.trail.name.ends_with?('Trails') ? 'are' : 'is'

    mail(to: alert.user.email, subject: "#{@alert.trail.name} #{is_or_are} now #{@alert.trail.status}.")
  end
end
