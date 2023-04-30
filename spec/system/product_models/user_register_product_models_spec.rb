require 'rails_helper'

describe 'Usuário cadastra um model de produto' do
  it 'com sucesso' do
    #Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'sac@samsung.com')
    other_supplier = Supplier.create!(brand_name: 'LG', corporate_name: 'LG Brasil LTDA',
                                  registration_number: '2726845743253', full_address: 'Av Ibirapuera, 100',
                                  city: 'São Paulo', state: 'SP', email: 'contato@lg.com')
    
    #Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: "TV 40'"
    fill_in 'Peso', with: 10_000
    fill_in 'Altura', with: 60
    fill_in 'Largura', with: 90
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV40-SAMSU-XPT900158'
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'
    #Assert
    expect(page).to have_content 'Modelo cadastrado com sucesso'
    expect(page).to have_content "TV 40'"
    expect(page).to have_content 'Fornecedor: Samsung'
    expect(page).to have_content 'SKU: TV40-SAMSU-XPT900158'
    expect(page).to have_content 'Dimensão: 60 cm x 90 cm x 10 cm'
    expect(page).to have_content 'Peso: 10000 g'
  end

  it 'deve preencher totos os campos' do
    #Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'sac@samsung.com')

    #Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: ''
    fill_in 'SKU', with: ''
    click_on 'Enviar'

    #Assert
    expect(page).to have_content 'Não foi possível cadastrar o modelo do produto'
  end
end