class Invoice < ApplicationRecord
  # Associations
  belongs_to :appointment
  has_many :invoice_items, dependent: :destroy
  has_many :products, through: :invoice_items

  # Enums
  enum :payment_status, { pending: 'pending', paid: 'paid', cancelled: 'cancelled' }

  # Validations
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_status, presence: true, inclusion: { in: payment_statuses.keys }

  # Callbacks
  after_save :update_total_amount

  # Scopes
  scope :ordered, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(payment_status: status) }
  scope :pending_payment, -> { where(payment_status: 'pending') }
  scope :paid, -> { where(payment_status: 'paid') }
  scope :recent, ->(days = 30) { where('created_at >= ?', days.days.ago) }

  # Instance methods
  def display_status
    case payment_status
    when 'pending'
      'Chờ thanh toán'
    when 'paid'
      'Đã thanh toán'
    when 'cancelled'
      'Đã hủy'
    end
  end

  def can_pay?
    pending?
  end

  def can_cancel?
    pending?
  end

  def add_product(product, quantity = 1)
    return false unless product.available? && product.stock >= quantity

    ActiveRecord::Base.transaction do
      # Create or update invoice item
      invoice_item = invoice_items.find_or_initialize_by(product: product)
      if invoice_item.persisted?
        invoice_item.quantity += quantity
      else
        invoice_item.quantity = quantity
        invoice_item.price = product.price
      end
      invoice_item.save!

      # Create inventory transaction
      InventoryTransaction.create!(
        product: product,
        quantity: quantity,
        transaction_type: 'OUT',
        source: "Bán hàng - Hóa đơn #{id}"
      )

      # Update total amount
      update_total_amount
    end
    true
  rescue => e
    Rails.logger.error "Error adding product to invoice: #{e.message}"
    false
  end

  def remove_product(product)
    invoice_item = invoice_items.find_by(product: product)
    return false unless invoice_item

    ActiveRecord::Base.transaction do
      quantity = invoice_item.quantity
      invoice_item.destroy!

      # Create inventory transaction to return stock
      InventoryTransaction.create!(
        product: product,
        quantity: quantity,
        transaction_type: 'IN',
        source: "Hoàn trả - Hóa đơn #{id}"
      )

      # Update total amount
      update_total_amount
    end
    true
  rescue => e
    Rails.logger.error "Error removing product from invoice: #{e.message}"
    false
  end

  def mark_as_paid
    update!(payment_status: 'paid')
  end

  def mark_as_cancelled
    update!(payment_status: 'cancelled')
  end

  private

  def update_total_amount
    new_total = invoice_items.sum('quantity * price')
    update_column(:total_amount, new_total) if new_total != total_amount
  end
end
