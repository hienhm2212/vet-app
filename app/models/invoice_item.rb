class InvoiceItem < ApplicationRecord
  # Associations
  belongs_to :invoice
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  before_validation :set_price_from_product, on: :create

  # Instance methods
  def subtotal
    quantity * price
  end

  def display_subtotal
    "#{subtotal.to_fs(:currency, unit: 'VND', format: '%u %n')}"
  end

  def display_price
    "#{price.to_fs(:currency, unit: 'VND', format: '%u %n')}"
  end

  private

  def set_price_from_product
    self.price = product.price if price.blank? && product
  end
end
