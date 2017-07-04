class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.integer :vehicle_id
      t.datetime :start_at
      t.datetime :end_at
      t.integer :user_id

      t.timestamps
    end

    add_index :bookings, :user_id
  end
end
