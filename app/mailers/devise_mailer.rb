class DeviseMailer < Devise::Mailer
  include Roadie::Rails::Automatic
  include Devise::Controllers::UrlHelpers

  default from: "MTB Trail Status <info@mtbtrailstat.us>"

  default template_path: 'devise/mailer'

  layout 'mailer'
end
