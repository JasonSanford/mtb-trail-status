class UpdatePhoneNumberLength < ActiveRecord::Migration
  def up
    change_column :users, :phone_number, :string, length: 12
  end

  def down
    change_column :users, :phone_number, :string, length: 10
  end
end
