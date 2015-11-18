class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  validates :term_start_date, :term_end_date, :stripe_customer_id, :stripe_subscription_id, :card_info, presence: true

  serialize :card_info, JSON

  def active?
    today = Date.today
    term_start_date <= today && term_end_date >= today
  end

  def cancel!
    customer = Stripe::Customer.retrieve(stripe_customer_id)
    customer.subscriptions.retrieve(stripe_subscription_id).delete
    self.update_attribute(:canceled, true)
  end
end
