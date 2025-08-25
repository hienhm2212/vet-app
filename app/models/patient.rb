class Patient < ApplicationRecord
  # Associations
  belongs_to :owner
  has_many :appointments, dependent: :destroy

  # Enums
  enum :gender, { male: "male", female: "female" }

  # Validations
  validates :name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :species, presence: true, length: { minimum: 2, maximum: 30 }
  validates :breed, length: { maximum: 50 }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 30 }, allow_nil: true
  validates :weight, numericality: { greater_than: 0, less_than: 1000 }, allow_nil: true

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :by_species, ->(species) { where(species: species) }
  scope :by_owner, ->(owner_id) { where(owner_id: owner_id) }

  # Instance methods
  def full_info
    "#{name} (#{species} - #{breed})"
  end

  def age_display
    age ? "#{age} tuổi" : "Chưa xác định"
  end

  def weight_display
    weight ? "#{weight} kg" : "Chưa xác định"
  end
end
