class HomeController < ApplicationController
  def index
    # Dashboard statistics
    @total_owners = Owner.count
    @total_patients = Patient.count
    @total_products = Product.count
    @total_appointments = Appointment.count
    @total_invoices = Invoice.count
    
    # Recent activities
    @recent_appointments = Appointment.includes(:patient => :owner)
                                    .order(created_at: :desc)
                                    .limit(5)
    
    @recent_invoices = Invoice.includes(:appointment => [:patient => :owner])
                             .order(created_at: :desc)
                             .limit(5)
    
    @recent_owners = Owner.order(created_at: :desc).limit(3)
    
    # Low inventory alerts
    @low_stock_products = Product.where('stock <= 10').order(:stock).limit(10)
    
    # Out of stock products
    @out_of_stock_products = Product.where(stock: 0).limit(5)
    
    # Today's appointments
    @today_appointments = Appointment.includes(:patient => :owner)
                                   .where(scheduled_at: Time.current.beginning_of_day..Time.current.end_of_day)
                                   .order(:scheduled_at)
    
    # Upcoming appointments (next 7 days)
    @upcoming_appointments = Appointment.includes(:patient => :owner)
                                      .where(scheduled_at: Time.current..Time.current + 7.days)
                                      .order(:scheduled_at)
                                      .limit(5)
    
    # Recent inventory transactions
    @recent_inventory_transactions = InventoryTransaction.includes(:product)
                                                        .order(created_at: :desc)
                                                        .limit(10)
    
    # Sales statistics (last 30 days)
    @recent_sales = Invoice.where(created_at: 30.days.ago..Time.current)
                          .where(payment_status: 'paid')
    
    @total_revenue_30_days = @recent_sales.sum(:total_amount) || 0
    @total_sales_count_30_days = @recent_sales.count
    
    # Chart data for appointments by status
    @appointments_by_status = Appointment.group(:status).count
    
    # Chart data for products by category
    @products_by_category = Product.group(:category).count
    
    # Chart data for recent sales (last 7 days)
    @daily_sales = Invoice.where(created_at: 7.days.ago..Time.current)
                         .where(payment_status: 'paid')
                         .group("DATE(created_at)")
                         .sum(:total_amount) || {}
    
    # Quick stats
    @pending_appointments = Appointment.where(status: 'scheduled').count
    @completed_appointments = Appointment.where(status: 'completed').count
    @cancelled_appointments = Appointment.where(status: 'cancelled').count
    
    @pending_payments = Invoice.where(payment_status: 'pending').count
    @paid_invoices = Invoice.where(payment_status: 'paid').count
    
    # Top selling products
    @top_selling_products = Product.joins(:invoice_items)
                                  .group('products.id')
                                  .order('SUM(invoice_items.quantity) DESC')
                                  .limit(5)
                                  .select('products.*, COALESCE(SUM(invoice_items.quantity), 0) as total_sold')
  rescue => e
    Rails.logger.error "Dashboard error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    
    # Fallback values
    @total_owners = 0
    @total_patients = 0
    @total_products = 0
    @total_appointments = 0
    @total_invoices = 0
    @recent_appointments = []
    @recent_invoices = []
    @recent_owners = []
    @low_stock_products = []
    @out_of_stock_products = []
    @today_appointments = []
    @upcoming_appointments = []
    @recent_inventory_transactions = []
    @total_revenue_30_days = 0
    @total_sales_count_30_days = 0
    @appointments_by_status = {}
    @products_by_category = {}
    @daily_sales = {}
    @pending_appointments = 0
    @completed_appointments = 0
    @cancelled_appointments = 0
    @pending_payments = 0
    @paid_invoices = 0
    @top_selling_products = []
  end
end
