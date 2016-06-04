class CreateInstagramPhotos < ActiveRecord::Migration
  def change
    create_table :instagram_photos do |t|
      t.string     :short_code, null: false
      t.references :trail,      null: false
      t.boolean    :processed,  null: false, default: false
      t.text       :json

      t.timestamps null: false
    end
  end
end
