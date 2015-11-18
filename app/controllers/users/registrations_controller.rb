class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def after_update_path_for(resource_or_scope)
    edit_settings_path
  end

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:phone_number)
    devise_parameter_sanitizer.for(:account_update).push(:phone_number)
  end
end
