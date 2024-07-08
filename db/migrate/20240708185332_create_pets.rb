class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :type, null: false
      t.string :tracker_type, null: false
      # TODO: should reference the user table for owner, out of scope for this task
      t.integer :owner_id, null: false
      t.boolean :in_zone, default: true
      t.boolean :lost_tracker, default: false

      t.timestamps
    end
  end
end
