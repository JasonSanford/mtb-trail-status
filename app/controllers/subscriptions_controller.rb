class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_plans,                only: [:new, :edit, :create]
  before_action :load_stripe,               only: [:new, :edit, :create]
  before_action :redirect_no_subscription,  only: [:edit]
  before_action :redirect_has_subscription, only: [:new]
  before_action :load_current_subscription, only: [:edit, :destroy, :new, :update, :create]

  def new

  end

  def edit

  end

  def create
    plan_id      = params[:plan]
    stripe_token = params[:stripe_token]

    begin
      customer = Stripe::Customer.create(
        source: stripe_token,
        plan:   plan_id,
        email:  current_user.email
      )
    rescue Stripe::CardError => e
      body  = e.json_body
      error = body[:error][:message]

      puts 'There was a problem with a card: ', body[:error]

      flash[:error] = "There was a problem with your card: #{error}"
      render new_subscription_path and return
    end
    stripe_subscription = customer.subscriptions.data[0]

    card_info = { last_4: params[:last_4], month: params[:exp_month],
                  year: params[:exp_year], brand: params[:brand] }


    plan       = Plan.find_by_stripe_id(plan_id)
    start_date = Time.at(stripe_subscription.current_period_start).to_date
    end_date   = Time.at(stripe_subscription.current_period_end).to_date

    @subscription = current_user.build_subscription(
      plan:                   plan,
      stripe_customer_id:     customer.id,
      stripe_subscription_id: stripe_subscription.id,
      card_info:              card_info,
      term_start_date:        start_date,
      term_end_date:          end_date)

    if @subscription.save
      flash[:success] = 'Your subscription is active!'
      redirect_to root_path
    else
      puts 'Error saving subscription: ', @subscription.errors.full_messages
      flash[:error] = 'There was a problem creating your subscription.'
      render new_subscription_path
    end
  end

  def update
    plan_id = params[:plan]
    plan    = Plan.find_by_stripe_id(plan_id)

    unless @current_subscription.canceled?
      @current_subscription.cancel!
    end

    customer            = Stripe::Customer.retrieve(@current_subscription.stripe_customer_id)
    stripe_subscription = customer.subscriptions.create(plan: plan.stripe_id)
    start_date          = Time.at(stripe_subscription.current_period_start).to_date
    end_date            = Time.at(stripe_subscription.current_period_end).to_date

    update_attrs = { term_start_date: start_date, term_end_date: end_date,
                     stripe_subscription_id: stripe_subscription.id, plan: plan,
                     canceled: false}

    if @current_subscription.update(update_attrs)
      flash[:success] = 'Your subscription is active!'
      redirect_to root_path
    else
      flash[:error] = 'There was a problem changing your subscription.'
      render :edit
    end
  end

  def destroy
    @current_subscription.cancel!
    flash[:notice] = 'Your subscription has been canceled.'
    redirect_to root_path
  end

private
  def load_plans
    @plans = Plan.all.order('name DESC')
  end

  def load_stripe
    @stripejs = true
  end

  def load_current_subscription
    @current_subscription = current_user.subscription
  end

  def redirect_no_subscription
    redirect_to new_subscription_path unless current_user.subscription
  end

  def redirect_has_subscription
    redirect_to edit_subscription_path if current_user.subscription
  end
end
