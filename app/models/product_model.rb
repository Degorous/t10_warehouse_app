class ProductModel < ApplicationRecord
  belongs_to :supplier
  validates :name, :weight, :width, :height, :depth, :sku,
            presence: true
  validates :sku, length: { is: 20 }
  validates :sku, uniqueness: true
  validate :greater_than_zero
end

def greater_than_zero
  if weight < 1 || width < 1 || height < 1 || depth < 1
    errors.add(:weight, 'Precisa ser maior que zero')
  end
end