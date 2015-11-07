class PhoneController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_blank_phone_number
  before_action :redirect_already_verified

  def verify
    reset_pin!
    text_pin!
  end

  def check_pin
    if params[:pin] == current_user.phone_pin
      flash[:success] = 'You successfully verified your phone number!'
      current_user.update_attribute('phone_verified', true)
      redirect_to(edit_profile_path)
    else
      flash[:error] = 'The PIN you entered did not match the PIN we sent. Try again.'
      render :verify
    end
  end

private
  def reset_pin!
    current_user.update_attribute('phone_pin', rand(0000..9999).to_s.rjust(4, '0'))
  end

  def text_pin!
    $twilio_client.messages.create(
      from: $twilio_phone_number,
      to: current_user.phone_number,
      body: "Hi there! This is MTB Trail Status verifying your phone number. Your PIN is #{current_user.phone_pin}."
    )
  end

  def redirect_blank_phone_number
    redirect_to(edit_profile_path) if current_user.phone_number.blank?
  end

  def redirect_already_verified
    redirect_to(edit_profile_path) if current_user.phone_verified
  end
end
