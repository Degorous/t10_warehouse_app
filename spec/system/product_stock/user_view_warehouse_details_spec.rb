require 'rails_helper'

describe 'Usário vê o estoque' do
  it 'na tela do galpão' do
    user = User.create!(name: 'Andre', email: 'andre@mail.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                          address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                          description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'sac@samsung.com')

    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    produto_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth:10,
                                      sku: 'TV32-SAMSU-XPT900158', supplier: supplier)
    produto_soundbar = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, depth:20,
                                            sku: 'SB71-SAMSU-XPT700153', supplier: supplier)
    produto_notebook = ProductModel.create!(name: 'Notebook i5 16Gb', weight: 2000, width: 40, height: 9, depth:20,
                                            sku: 'NTBK-SAMSU-XPT700351', supplier: supplier)

    3.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_tv) }
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_notebook) }

    login_as user
    visit root_path
    click_on 'Aeroporto SP'
    
    within "section#stock_products" do
      expect(page).to have_content 'Itens em Estoque'
      expect(page).to have_content '3 x TV32-SAMSU-XPT900158'
      expect(page).to have_content '2 x NTBK-SAMSU-XPT700351'
      expect(page).not_to have_content 'SB71-SAMSU-XPT700153'
    end
  end

  it 'e dá baixa em um item' do
    user = User.create!(name: 'Andre', email: 'andre@mail.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                          address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                          description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'sac@samsung.com')

    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    produto_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth:10,
                                      sku: 'TV32-SAMSU-XPT900158', supplier: supplier)

    2.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_tv) }

    login_as user
    visit root_path
    click_on 'Aeroporto SP'
    select 'TV32-SAMSU-XPT900158', from: 'Item para Saída'
    fill_in 'Destinatário', with: 'Maria Ferreira'
    fill_in 'Endereço Destino', with: 'Rua das Palmeiras, 100 - Campinas - SP'
    click_on 'Confirmar Retirada'

    expect(current_path).to eq warehouse_path(w.id)
    expect(page).to have_content 'Item retirado com sucesso'
    expect(page).to have_content '1 x TV32-SAMSU-XPT900158'
  end
end