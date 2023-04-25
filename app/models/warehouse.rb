class Warehouse < ApplicationRecord
  validates :name, :code, :city, :description, :address, :cep, :area,
           presence: true
  validates :code, uniqueness: true
end
