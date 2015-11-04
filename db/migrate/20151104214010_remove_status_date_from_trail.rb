class RemoveStatusDateFromTrail < ActiveRecord::Migration
  def change
    remove_column :trails, :status_date, :datetime
  end
end
