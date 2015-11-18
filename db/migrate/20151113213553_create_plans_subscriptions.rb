class CreatePlansSubscriptions < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string  :name,           null: false
      t.integer :price_in_cents, null: false
      t.string  :stripe_id,      null: false

      t.timestamps null: false
    end

    create_table :subscriptions do |t|
      t.integer :user_id,                null: false
      t.integer :plan_id,                null: false
      t.date    :term_start_date,        null: false
      t.date    :term_end_date,          null: false
      t.string  :stripe_customer_id,     null: false
      t.string  :stripe_subscription_id, null: false
      t.boolean :canceled,               null: false, default: false
      t.text    :card_info,              null: false

      t.timestamps null: false
    end

    add_column :users, :is_free, :boolean, null: false, default: false
  end
end
