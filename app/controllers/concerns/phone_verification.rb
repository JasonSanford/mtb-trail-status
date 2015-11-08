module PhoneVerification
  extend ActiveSupport::Concern

private
  def redirect_not_verified
    unless current_user.phone_verified
      flash[:notice] = 'Please verify your phone number first.'
      redirect_to(edit_profile_path)
    end
  end

  def redirect_blank_phone_number
    if current_user.phone_number.blank?
      flash[:notice] = 'Please enter your phone number first.'
      redirect_to(edit_profile_path)
    end
  end

  def redirect_already_verified
    if current_user.phone_verified
      redirect_to(edit_profile_path)
    end
  end
end
