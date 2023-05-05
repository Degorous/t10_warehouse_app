class Warehouse < ApplicationRecord
  validates :name, :code, :city, :description, :address, :cep, :area,
           presence: true
  validates :code, uniqueness: true
  validate :cep_checker
  
  def full_description
    "#{code} - #{name}"
  end
  
  def cep_checker
    split_cep = cep.split('-')
    if cep.present? && (split_cep.first.size != 5 || split_cep.second.size != 3)
      errors.add(:cep, 'Precisa estar no formato XXXXX-XXX')
    end
  end
end