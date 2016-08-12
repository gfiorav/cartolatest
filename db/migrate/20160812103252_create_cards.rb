class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :username, null: false
      t.string :organization, null: false
      t.string :privacy, null: false, defualt: 'private'
      t.uuid :visualization_id, null: false
      t.timestamps
    end
  end
end
