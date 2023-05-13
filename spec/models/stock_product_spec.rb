require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'gera um número de série' do
    it 'ao criar um StockProduct' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now,
                            status: :delivered)

      product = ProductModel.create!(name: 'Produto A', weight: 11, width: 10, height: 20, depth: 30,
        supplier: supplier, sku: 'PD0A-ACMEX-XPT900158')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      expect(stock_product.serial_number.length).to eq 20
    end

    it 'e não é modificado' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      other_warehouse = Warehouse.create!(name: 'Guarulhos', code: 'GRU', city: 'Guarulhos', description: 'Alguma descrição',
                                      address: 'Endereço', cep: '15000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now,
                            status: :delivered)

      product = ProductModel.create!(name: 'Produto A', weight: 11, width: 10, height: 20, depth: 30,
        supplier: supplier, sku: 'PD0A-ACMEX-XPT900158')
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      original_serial_number = stock_product.serial_number

      stock_product.update!(warehouse: other_warehouse)

      expect(stock_product.serial_number).to eq original_serial_number
    end
  end

  describe '#available' do
    it 'true se não tiver destino' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now,
                            status: :delivered)

      product = ProductModel.create!(name: 'Produto A', weight: 11, width: 10, height: 20, depth: 30,
        supplier: supplier, sku: 'PD0A-ACMEX-XPT900158')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      expect(stock_product.available?).to eq true
    end

    it 'false se tiver destino' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now,
                            status: :delivered)

      product = ProductModel.create!(name: 'Produto A', weight: 11, width: 10, height: 20, depth: 30,
        supplier: supplier, sku: 'PD0A-ACMEX-XPT900158')

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      stock_product.create_stock_product_destination!(recipient: 'Joao', address: 'Rua do Joao')

      expect(stock_product.available?).to eq false
    end
  end
end
