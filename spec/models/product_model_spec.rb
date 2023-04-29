require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    it 'name é obrigatório' do
      #Arrange
      supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                  registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                  city: 'Bauru', state: 'SP', email: 'sac@samsung.com')

      pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth:10,
                            sku: 'TV32-SAMSU-XPT900158', supplier: supplier)
      #Act
      result = pm.valid?
      #Assert
      expect(result).to eq false
    end

    it 'sku é obrigatório' do
      #Arrange
      supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                  registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                  city: 'Bauru', state: 'SP', email: 'sac@samsung.com')

      pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth:10,
                            sku: '', supplier: supplier)
      #Act
      result = pm.valid?
      #Assert
      expect(result).to eq false
    end
  end
end
