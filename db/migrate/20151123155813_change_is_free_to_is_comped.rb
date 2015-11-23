class ChangeIsFreeToIsComped < ActiveRecord::Migration
  def up
    rename_column :users, :is_free, :is_comped
  end

  def down
    rename_column :users, :is_comped, :is_free
  end
end
