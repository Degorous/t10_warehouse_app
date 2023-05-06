require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
    andre = User.create!(name: 'Andre', email: 'andre@email.com', password: 'password')
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(andre)
    patch(order_path(order.id), params: {order: {supplier_id: 3}})

    expect(response).to redirect_to root_path
  end
end