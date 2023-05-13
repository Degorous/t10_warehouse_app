require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-10-01')

      #Act
      order.valid?

      #Assert
      expect(order.valid?).to be true
    end

    it 'data estimada de entrega deve ser obrigatória' do
      #Arrange
      order = Order.new(estimated_delivery_date: '')
      
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      expect(result).to be true
    end

    it 'data estimada de entrega não deve ser passada' do
      order = Order.new(estimated_delivery_date: 1.day.ago)

      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include('Deve ser uma data futura')
    end

    it 'data estimada de entrega não deve ser igual a hoje' do
      order = Order.new(estimated_delivery_date: Date.today)

      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      expect(result).to be true
      expect(order.errors[:estimated_delivery_date]).to include('Deve ser uma data futura')
    end

    it 'data estimada de entrega deve ser igual ou maior do que amanhã' do
      order = Order.new(estimated_delivery_date: 1.day.from_now)

      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      expect(result).to be false
    end
  end

  describe 'Gera um código aleatório' do
    it 'ao criar um novo pedido' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.new( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-10-01')  
      #Act
      order.save!
      result = order.code
      #Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 10
    end

    it 'e o código é único' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      first_order = Order.create!( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-10-01')
      second_order = Order.new( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-11-15')  

      #Act
      second_order.save!
      #Assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                    address: 'Endereço', cep: '25000-000', area: 1000)
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!( user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now)
      original_code = order.code

      order.update!(estimated_delivery_date: 1.month.from_now)

      expect(order.code).to eq original_code
    end
  end
end
