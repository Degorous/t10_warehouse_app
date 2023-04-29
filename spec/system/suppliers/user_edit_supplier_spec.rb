require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'a partir da página de detalhes' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
                     registration_number: '4920923546604', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    #Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    click_on 'ACME'
    click_on 'Editar'

    #Assert
    expect(page).to have_content 'Editar Fornecedor'
    expect(page).to have_field 'Razão Social', with: 'ACME LTDA'
    expect(page).to have_field 'Nome Fantasia', with: 'ACME'
    expect(page).to have_field 'CNPJ', with: '4920923546604'
    expect(page).to have_field 'Endereço', with: 'Av das Palmas, 100'
    expect(page).to have_field 'Cidade', with: 'Bauru'
    expect(page).to have_field 'Estado', with: 'SP'
    expect(page).to have_field 'E-mail', with: 'contato@acme.com'
  end

  it 'com sucesso' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
      registration_number: '4920923546604', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    #Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    click_on 'ACME'
    click_on 'Editar'
    fill_in 'CNPJ', with: '4920923546699'
    fill_in 'Endereço', with: 'Av das Feijoadas, 100'
    click_on 'Enviar'

    #Assert
    expect(page).to have_content 'Fornecedor atualizado com sucesso'
    expect(page).to have_content 'CNPJ: 4920923546699'
    expect(page).to have_content 'Endereço: Av das Feijoadas, 100'
  end

  it 'e mantém os campos obrigatórios' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME',
      registration_number: '4920923546604', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    #Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    click_on 'ACME'
    click_on 'Editar'
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: ''
    click_on 'Enviar'

    #Assert
    expect(page).to have_content 'Não foi possível atualizar o fornecedor'
  end
end