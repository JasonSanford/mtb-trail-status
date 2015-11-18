namespace :customers do
  desc 'Delete all customers in the test environment'
  task delete_all: :environment do
    unless Rails.env.production?
      Stripe::Customer.all.each do |customer|
        customer.delete
      end
    end
  end
end
