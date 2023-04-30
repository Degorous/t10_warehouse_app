require 'rails_helper'

describe 'Usuário vê modelos de produtos' do
  it 'se estiver autenticado' do
    #Arrange

    #Act
    visit root_path
    click_on 'Entrar'
    within 'nav' do
      click_on 'Modelos de Produtos'
    end

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    #Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Modelos de Produtos'
    end

    #Assert
    expect(current_path).to eq product_models_path
  end

  it 'com sucesso' do 
    #Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '4920923546604', full_address: 'Av das Palmas, 100',
                                city: 'Bauru', state: 'SP', email: 'sac@samsung.com')

    ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth:10,
                         sku: 'TV32-SAMSU-XPT900158', supplier: supplier)
    ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 15, depth:20,
      sku: 'SB71-SAMSU-XPT700153', supplier: supplier)

    #Act
    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Modelos de Produtos'
    end

    #Assert
    expect(page).to have_content 'TV 32'
    expect(page).to have_content 'TV32-SAMSU-XPT900158'
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'SoundBar 7.1 Surround'
    expect(page).to have_content 'SB71-SAMSU-XPT700153'
    expect(page).to have_content 'Samsung'
  end

  it 'e não existem produtos cadastrados' do
    #Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
    within 'nav' do
      click_on 'Modelos de Produtos'
    end
    #Assert
    expect(page).to have_content 'Nenhum modelo de produto cadastrado'
  end
end