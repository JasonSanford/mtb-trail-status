class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  validates :phone_number, phony_plausible: true

  before_save :set_phone_verified

private
  def set_phone_verified
    if phone_number_changed?
      self.phone_verified = false
      self.phone_pin      = rand(0000..9999).to_s.rjust(4, '0')
    end
  end
end
