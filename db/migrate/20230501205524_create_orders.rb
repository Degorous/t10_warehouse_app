class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :warehouse, null: false, foreign_key: true
      t.belongs_to :supplier, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.date :estimated_delivery_date

      t.timestamps
    end
  end
end
