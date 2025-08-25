class InventoryTransaction < ApplicationRecord
  # Associations
  belongs_to :product

  # Enums
  enum :transaction_type, { in: "IN", out: "OUT" }

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: transaction_types.keys }
  validates :source, presence: true, length: { minimum: 2, maximum: 100 }

  # Callbacks
  after_create :update_product_stock

  # Scopes
  scope :ordered, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(transaction_type: type) }
  scope :by_product, ->(product_id) { where(product_id: product_id) }
  scope :recent, ->(days = 30) { where("created_at >= ?", days.days.ago) }

  # Instance methods
  def display_type
    transaction_type == "IN" ? "Nhập kho" : "Xuất kho"
  end

  private

  def update_product_stock
    product.update_stock(quantity, transaction_type)
  end
end
