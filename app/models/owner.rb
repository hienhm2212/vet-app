class Owner < ApplicationRecord
  # Associations
  has_many :patients, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :phone, presence: true, uniqueness: true,
            format: { with: /\A(\+84|0)[0-9]{9,10}\z/, message: "phải có định dạng số điện thoại Việt Nam hợp lệ" }
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "không hợp lệ" }

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :search, ->(query) { where("name LIKE ? OR phone LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%") }

  # Instance methods
  def full_info
    "#{name} - #{phone}"
  end
end
