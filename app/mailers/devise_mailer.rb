class DeviseMailer < Devise::Mailer
  include Roadie::Rails::Automatic
  include Devise::Controllers::UrlHelpers

  default template_path: 'devise/mailer'

  layout 'mailer'
end
