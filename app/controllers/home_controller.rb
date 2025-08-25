class HomeController < ApplicationController
  def index
    begin
      # Get basic statistics
      @total_owners = Owner.count
      @total_patients = Patient.count
      @total_appointments = Appointment.count
      @total_invoices = Invoice.count

      # Get recent activities
      @recent_invoices = Invoice.includes(appointment: [ patient: :owner ])
                                .order(created_at: :desc)
                                .limit(5)

      @recent_appointments = Appointment.includes(patient: :owner)
                                       .order(created_at: :desc)
                                       .limit(5)

      # Get today's appointments
      @today_appointments = Appointment.includes(patient: :owner)
                                      .where(scheduled_at: Time.current.beginning_of_day..Time.current.end_of_day)
                                      .order(:scheduled_at)

      # Get upcoming appointments (next 7 days)
      @upcoming_appointments = Appointment.includes(patient: :owner)
                                         .where(scheduled_at: Time.current..1.week.from_now)
                                         .order(:scheduled_at)
                                         .limit(10)

      # Get low stock products
      @low_stock_products = Product.where("stock <= 10 AND stock > 0")
                                  .order(:stock)
                                  .limit(5)

      # Get out of stock products
      @out_of_stock_products = Product.where(stock: 0)
                                     .order(:name)
                                     .limit(5)

      # Get recent inventory transactions
      @recent_inventory_transactions = InventoryTransaction.includes(:product)
                                                          .order(created_at: :desc)
                                                          .limit(10)

      # Get top selling products (based on invoice items)
      @top_selling_products = Product.joins(:invoice_items)
                                    .group("products.id")
                                    .order("COUNT(invoice_items.id) DESC")
                                    .limit(5)

      # Get daily sales for the last 7 days
      @daily_sales = Invoice.where(created_at: 1.week.ago..Time.current)
                           .group("DATE(created_at)")
                           .sum(:total_amount) || {}

    rescue => e
      # Fallback values if any query fails
      @total_owners = 0
      @total_patients = 0
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
      @top_selling_products = []
      @daily_sales = {}
    end
  end
end
