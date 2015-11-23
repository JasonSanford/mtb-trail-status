class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'
  validates :phone_number, phony_plausible: true

  validates :email, uniqueness: true
  validates :phone_number, uniqueness: true, allow_nil: true

  after_save :set_phone_verified

  has_one :subscription, dependent: :destroy
  has_many :alerts, dependent: :destroy

  def can_receive_texts?
    if phone_verified?
      if is_comped?
        true
      else
        subscription && subscription.active?
      end
    else
      false
    end
  end

  def reasons_for_not_receiving_texts
    reasons = []
    reasons << 'Phone number is not verified.' unless phone_verified?
    reasons << 'Subscription is not active.'   unless subscription && subscription.active?
    reasons
  end

private
  def set_phone_verified
    if phone_number_changed?
      self.update_column(:phone_verified, false)
    end
  end
end
