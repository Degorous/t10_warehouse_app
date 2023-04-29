require 'rails_helper'

describe 'Usuário vê detalhes de um galpão' do
  it 'a partir da tela inicial' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
      full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    #Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    click_on 'ACME'

    #Assert
    expect(page).to have_content 'ACME LTDA'
    expect(page).to have_content 'CNPJ: 4920923546604'
    expect(page).to have_content 'Endereço: Av das Palmas, 100'
    expect(page).to have_content 'E-mail: contato@acme.com'
  end

  it 'e volta para tela inicial' do
    #Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4920923546604',
      full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')

    #Act
    visit root_path
    within 'nav' do
      click_on 'Fornecedores'
    end
    click_on 'ACME'
    within 'nav' do
      click_on 'Início'
    end
    
    #Assert
    expect(current_path).to eq root_path
  end
end