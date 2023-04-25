require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        #Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                  address: 'Endereço', cep: '25000-00', area: 1000)
  
        #Act
        result = warehouse.valid?
  
        #Assert
        expect(result).to eq false
      end
  
      it 'false when code is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', city: 'Rio', description: 'Alguma descrição',
                                  address: 'Endereço', cep: '25000-00', area: 1000)
  
        #Act
        result = warehouse.valid?
  
        #Assert
        expect(result).to eq false
      end
  
      it 'false when city is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', city: '', description: 'Alguma descrição',
                                  address: 'Endereço', cep: '25000-00', area: 1000)
  
        #Act
        result = warehouse.valid?
  
        #Assert
        expect(result).to eq false
      end
    end

    it 'false when code is already in use' do
      #Arrange
      first_warehouse = Warehouse.create(name: 'Rio', code: 'RIO', city: 'Rio', description: 'Alguma descrição',
                                         address: 'Endereço', cep: '25000-00', area: 1000)

      second_warehouse = Warehouse.new(name: 'Niterói', code: 'RIO', city: 'Niterói', description: 'Outra descrição',
                                       address: 'Avenida', cep: '35000-00', area: 1500)

      #Act
      result = second_warehouse.valid?

      #Assert
      expect(result).to eq false

    end
  end
end
