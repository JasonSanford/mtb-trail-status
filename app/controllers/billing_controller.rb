class BillingController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_no_subscription

  def index
    @stripe_customer = Stripe::Customer.retrieve(current_user.subscription.stripe_customer_id)
    @invoices = @stripe_customer.invoices

    if @stripe_customer
      @upcoming_invoice =
        begin
          Stripe::Invoice.upcoming(customer: current_user.subscription.stripe_customer_id)
        rescue Stripe::InvalidRequestError
          nil
        end
    end
  end

private
  def redirect_no_subscription
    redirect_to root_path unless current_user.subscription
  end
end
