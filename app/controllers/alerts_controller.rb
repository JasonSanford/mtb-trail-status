class AlertsController < ApplicationController
  include PhoneVerification

  before_action :authenticate_user!
  before_action :redirect_blank_phone_number
  before_action :redirect_not_verified

  def index

  end
end
