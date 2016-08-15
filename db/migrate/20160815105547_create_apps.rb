class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.string :app_id, null: false
      t.string :app_key, null: false

      t.timestamps
    end
  end
end
