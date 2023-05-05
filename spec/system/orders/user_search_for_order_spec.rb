require 'rails_helper'

describe 'Usuário busca por um pedido' do
  it 'a partir do menu' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')

    login_as(user)
    visit root_path

    within 'header nav' do
      expect(page).to have_field 'Buscar Pedido'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'a partir do menu' do
    visit root_path

    within 'header nav' do
      expect(page).not_to have_field 'Buscar Pedido'
      expect(page).not_to have_button 'Buscar'
    end
  end

  it 'e encontra um pedido' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    expect(page).to have_content "Resultados da busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'Galpão de Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME'
  end

  it 'encontra múltiplos pedidos' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    first_warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    second_warehouse = Warehouse.create(name: 'Aeroporto Rio', code: 'SDU', city: 'Rio de Janeiro', area: 100_000,
                                 address: 'Av. do Porto, 80', cep: '25000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    allow(SecureRandom).to receive(:alphanumeric).and_return('GRU1234567')
    first_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).and_return('GRU9876543')
    second_order = Order.create!(user: user, warehouse: first_warehouse, supplier: supplier,
                                 estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).and_return('SDU0000000')
    third_order = Order.create!(user: user, warehouse: second_warehouse, supplier: supplier,
                                estimated_delivery_date: 1.day.from_now)

    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'GRU'
    click_on 'Buscar'

    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'GRU1234567'
    expect(page).to have_content 'GRU9876543'
    expect(page).to have_content 'Galpão de Destino: GRU - Aeroporto SP'
    expect(page).not_to have_content 'SDU0000000'
    expect(page).not_to have_content 'Galpão de Destino: SDU - Aeroporto Rio'
  end
end