class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
