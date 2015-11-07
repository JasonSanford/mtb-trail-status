class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  validates :phone_number, phony_plausible: true

  after_save :set_phone_verified

private
  def set_phone_verified
    if phone_number_changed?
      self.update_column(:phone_verified, false)
    end
  end
end
