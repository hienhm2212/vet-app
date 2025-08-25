class Product < ApplicationRecord
  # Associations
  has_many :inventory_transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :category, presence: true, length: { minimum: 2, maximum: 50 }
  validates :product_type, presence: true, inclusion: { in: %w[Hộp Túi Bịch Cái Chai Lọ Gói Viên] }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :supplier, length: { maximum: 100 }
  validates :barcode, presence: true, uniqueness: true, length: { minimum: 8, maximum: 20 }

  # Callbacks
  before_validation :generate_barcode, on: :create

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_type, ->(type) { where(product_type: type) }
  scope :in_stock, -> { where('stock > 0') }
  scope :low_stock, -> { where('stock <= 10') }
  scope :search, ->(query) { where("name LIKE ? OR category LIKE ? OR supplier LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%") }

  # Class methods
  def self.available_types
    %w[Hộp Túi Bịch Cái Chai Lọ Gói Viên]
  end

  # Instance methods
  def available?
    stock > 0
  end

  def low_stock?
    stock <= 10
  end

  def update_stock(quantity, transaction_type)
    case transaction_type
    when 'IN'
      self.stock += quantity
    when 'OUT'
      if self.stock >= quantity
        self.stock -= quantity
      else
        raise "Không đủ hàng trong kho"
      end
    end
    save!
  end

  def generate_barcode_png
    BarcodeService.generate_product_barcode(self)
  end

  def generate_thermal_barcode_png
    BarcodeService.generate_thermal_barcode(self)
  end

  def generate_adhesive_label_barcode_png
    BarcodeService.generate_adhesive_label_barcode(self)
  end

  def generate_barcode_pdf
    # Format: barcode only (for scanning)
    barcode_text = self.barcode
    barcode = Barby::Code128.new(barcode_text)
    barcode.to_pdf(height: 60, margin: 10)
  end

  private

  def generate_barcode
    return if barcode.present?
    
    loop do
      # Generate a 12-digit barcode
      new_barcode = "VN#{SecureRandom.random_number(10**10).to_s.rjust(10, '0')}"
      unless Product.exists?(barcode: new_barcode)
        self.barcode = new_barcode
        break
      end
    end
  end
end
