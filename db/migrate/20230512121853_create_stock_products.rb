class CreateStockProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_products do |t|
      t.belongs_to :warehouse, null: false, foreign_key: true
      t.belongs_to :order, null: false, foreign_key: true
      t.belongs_to :product_model, null: false, foreign_key: true
      t.string :serial_number

      t.timestamps
    end
  end
end
