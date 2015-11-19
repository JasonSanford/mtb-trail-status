class AlertsController < ApplicationController
  include PhoneVerification
  include TrailLoader

  before_action :authenticate_user!
  before_action :redirect_no_subscription
  before_action :redirect_blank_phone_number
  before_action :redirect_not_verified
  before_action :load_trails, only: [:index]

  def index
    @nav = 'alerts'
    @toggle = true
    @current_alert_trails = current_user.alerts.collect{ |a| a.trail }
  end

  def create
    trail_ids = params[:trail][:ids].map!(&:to_i)

    trail_ids.each do |trail_id|
      trail = Trail.find trail_id
      Alert.find_or_create_by(user: current_user, trail: trail)
    end

    current_user.alerts.each do |alert|
      alert.destroy unless trail_ids.include?(alert.trail.id)
    end

    flash[:success] = 'Your trail alerts were updated!'
    redirect_to alerts_path
  end

private
  def redirect_no_subscription
    is_free                 = current_user.is_free?
    has_active_subscription = current_user.subscription && current_user.subscription.active?

    unless is_free || has_active_subscription
      flash[:notice] = 'You need a subscription before setting up trail text alerts.'
      redirect_to new_subscription_path
    end
  end
end
