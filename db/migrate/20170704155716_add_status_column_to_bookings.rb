class AddStatusColumnToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :status, :integer, default: 0
  end
end
