class AlertsController < ApplicationController
  include PhoneVerification
  include TrailLoader

  before_action :authenticate_user!
  before_action :redirect_blank_phone_number
  before_action :redirect_not_verified
  before_action :load_trails, only: [:index]

  def index
    @nav = 'alerts'
    @current_email_alert_trails = current_user.alerts.where(email: true).collect{ |a| a.trail }
    @current_sms_alert_trails   = current_user.alerts.where(sms: true).collect{ |a| a.trail }
  end

  def create
    trail_sms_ids   = params[:trail_sms]   ? params[:trail_sms][:ids].map!(&:to_i)   : []
    trail_email_ids = params[:trail_email] ? params[:trail_email][:ids].map!(&:to_i) : []

    trail_sms_ids.each do |trail_id|
      trail = Trail.find trail_id
      alert = Alert.find_or_initialize_by(user: current_user, trail: trail)
      alert.sms = true
      alert.save
    end

    trail_email_ids.each do |trail_id|
      trail = Trail.find trail_id
      alert = Alert.find_or_initialize_by(user: current_user, trail: trail)
      alert.email = true
      alert.save
    end

    current_user.alerts.each do |alert|
      alert.sms   = false unless trail_sms_ids.include?(alert.trail.id)
      alert.email = false unless trail_email_ids.include?(alert.trail.id)

      if alert.sms || alert.email
        alert.save
      else
        alert.destroy
      end
    end

    flash[:success] = 'Your trail alerts were updated!'
    redirect_to alerts_path
  end
end
