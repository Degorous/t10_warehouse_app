class Supplier < ApplicationRecord
  has_many :product_models
  validates :corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email,
           presence: true
  validates :state, length: { is: 2}
  validates :registration_number, length: { is: 13}
  validates :registration_number, uniqueness: true

  def full_description
    "#{brand_name} - #{registration_number}"
  end
end
