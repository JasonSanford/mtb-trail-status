module ApplicationHelper
  def body_class
    [controller.controller_name, controller.action_name].compact.join(" ")
  end
end
