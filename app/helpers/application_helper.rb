module ApplicationHelper
  def bootstrap_alert_type(type)
    types = {
      alert:   'alert-warning',
      error:   'alert-danger',
      notice:  'alert-info',
      success: 'alert-success'
    }

    types[type.to_sym] || type.to_s
  end

  def body_class
    [controller.controller_name, controller.action_name].compact.join(" ")
  end
end
