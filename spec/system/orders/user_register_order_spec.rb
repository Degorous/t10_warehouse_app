require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    #Arrange

    #Act
    visit root_path
    click_on 'Registrar Pedido'

    #Assert
    expect(current_path).to eq new_user_session_path

  end

  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,address: 'Av Atlantica, 50',
                      cep: '80000-000', description: 'Perto do aeroporto')
    warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    Supplier.create!(corporate_name:'Spark Industries LATDA', brand_name: 'Spark',registration_number: '9857157961388',
                     full_address: 'Av da Industria, 10', city: 'Teresina', state: 'PI', email: 'vendas@spark.com')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
    allow(SecureRandom).to receive(:alphanumeric).and_return('5KIAMXNLUO')
                                  
    #Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão de Destino'
    select supplier.brand_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: '20/12/2023'
    click_on 'Gravar'

    #Assert
    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content '5KIAMXNLUO'
    expect(page).to have_content 'Galpão de Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME - 4920923546604'
    expect(page).to have_content 'Usuário Responsável: Sergio - sergio@email.com'
    expect(page).to have_content 'Data Prevista de Entrega: 20/12/2023'
    expect(page).not_to have_content 'Maceio'
    expect(page).not_to have_content 'Spark'
  end

  it 'e não informa a data de entrega' do
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Av. do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
                                full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
    
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão de Destino'
    select supplier.brand_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: ''
    click_on 'Gravar'

    expect(page).to have_content 'Não foi possível registrar o pedido'
    expect(page).to have_content 'Data Prevista de Entrega não pode ficar em branco'
  end
end