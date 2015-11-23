class AddSmsEmailToAlert < ActiveRecord::Migration
  def up
    add_column :alerts, :sms,   :boolean, null: false, default: false
    add_column :alerts, :email, :boolean, null: false, default: false

    # Forgot to null: false these the first round through
    change_column :alerts, :user_id,    :integer,  null: false
    change_column :alerts, :trail_id,   :integer,  null: false
    change_column :alerts, :created_at, :datetime, null: false
    change_column :alerts, :updated_at, :datetime, null: false
  end

  def down
    remove_column :alerts, :sms,   :boolean, null: false, default: false
    remove_column :alerts, :email, :boolean, null: false, default: false

    change_column :alerts, :user_id,    :integer,  null: true
    change_column :alerts, :trail_id,   :integer,  null: true
    change_column :alerts, :created_at, :datetime, null: true
    change_column :alerts, :updated_at, :datetime, null: true
  end
end
