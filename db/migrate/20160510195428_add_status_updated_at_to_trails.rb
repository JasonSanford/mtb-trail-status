class AddStatusUpdatedAtToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :status_updated_at, :datetime, null: false, default: Time.now
  end
end
