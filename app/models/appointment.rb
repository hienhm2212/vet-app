class Appointment < ApplicationRecord
  # Associations
  belongs_to :patient
  has_one :invoice, dependent: :destroy

  # Enums
  enum :status, { scheduled: 'scheduled', in_progress: 'in_progress', completed: 'completed', cancelled: 'cancelled' }
  enum :appointment_type, { consultation: 'consultation', vaccination: 'vaccination', surgery: 'surgery', checkup: 'checkup' }

  # Validations
  validates :veterinarian_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :scheduled_at, presence: true
  validates :appointment_type, presence: true, inclusion: { in: appointment_types.keys }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validate :scheduled_at_cannot_be_in_the_past, on: :create

  # Callbacks
  after_create :create_invoice

  # Scopes
  scope :ordered, -> { order(scheduled_at: :asc) }
  scope :upcoming, -> { where('scheduled_at >= ?', Time.current).where(status: 'scheduled') }
  scope :today, -> { where(scheduled_at: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_veterinarian, ->(name) { where(veterinarian_name: name) }

  # Instance methods
  def display_status
    case status
    when 'scheduled'
      'Đã lên lịch'
    when 'in_progress'
      'Đang khám'
    when 'completed'
      'Hoàn thành'
    when 'cancelled'
      'Đã hủy'
    end
  end

  def display_type
    case appointment_type
    when 'consultation'
      'Tư vấn'
    when 'vaccination'
      'Tiêm chủng'
    when 'surgery'
      'Phẫu thuật'
    when 'checkup'
      'Khám bệnh'
    end
  end

  def can_cancel?
    scheduled? && scheduled_at > 2.hours.from_now
  end

  def can_complete?
    in_progress?
  end

  private

  def scheduled_at_cannot_be_in_the_past
    if scheduled_at.present? && scheduled_at < Time.current
      errors.add(:scheduled_at, "không thể là thời gian trong quá khứ")
    end
  end

  def create_invoice
    create_invoice!(total_amount: 0.0, payment_status: 'pending')
  end
end
