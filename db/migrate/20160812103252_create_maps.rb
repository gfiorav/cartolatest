class CreateMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :maps do |t|
      t.string :username, null: false
      t.string :organization
      t.string :privacy, null: false, defualt: 'private'
      t.uuid :visualization_id, null: false, unique: true
      t.timestamp :published_at, null: false
      t.timestamps
    end
  end
end
