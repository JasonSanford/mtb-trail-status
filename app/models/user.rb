class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  validates :phone_number, phony_plausible: true
end
