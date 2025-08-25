class InvoicesController < ApplicationController
  before_action :set_appointment
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices
  def index
    @invoices = @appointment.invoices.ordered
  end

  # GET /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/1
  def show
  end

  # GET /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/new
  def new
    @invoice = @appointment.invoices.build
  end

  # GET /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/1/edit
  def edit
  end

  # POST /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices
  def create
    @invoice = @appointment.invoices.build(invoice_params)

    if @invoice.save
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], notice: t('flash.invoices.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/1
  def update
    if @invoice.update(invoice_params)
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], notice: t('flash.invoices.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/1
  def destroy
    @invoice.destroy
    redirect_to owner_patient_appointment_invoices_url(@appointment.patient.owner, @appointment.patient, @appointment), notice: t('flash.invoices.destroyed')
  end

  # POST /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/:id/add_product_by_barcode
  def add_product_by_barcode
    @invoice = @appointment.invoices.find(params[:id])
    barcode = params[:barcode]
    quantity = params[:quantity]&.to_i || 1

    product = Product.find_by(barcode: barcode)
    
    if product.nil?
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], alert: 'Không tìm thấy sản phẩm với mã vạch này'
      return
    end

    if @invoice.add_product(product, quantity)
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], notice: t('flash.invoices.product_added')
    else
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], alert: 'Không thể thêm sản phẩm vào hóa đơn'
    end
  end

  # DELETE /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/:id/remove_product/:product_id
  def remove_product
    @invoice = @appointment.invoices.find(params[:id])
    product = Product.find(params[:product_id])

    if @invoice.remove_product(product)
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], notice: 'Sản phẩm đã được xóa khỏi hóa đơn'
    else
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], alert: 'Không thể xóa sản phẩm khỏi hóa đơn'
    end
  end

  # PATCH /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/:id/mark_as_paid
  def mark_as_paid
    @invoice = @appointment.invoices.find(params[:id])
    if @invoice.mark_as_paid
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], notice: 'Hóa đơn đã được thanh toán'
    else
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], alert: 'Không thể thanh toán hóa đơn'
    end
  end

  # PATCH /owners/:owner_id/patients/:patient_id/appointments/:appointment_id/invoices/:id/mark_as_cancelled
  def mark_as_cancelled
    @invoice = @appointment.invoices.find(params[:id])
    if @invoice.mark_as_cancelled
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], notice: 'Hóa đơn đã được hủy'
    else
      redirect_to [@appointment.patient.owner, @appointment.patient, @appointment, @invoice], alert: 'Không thể hủy hóa đơn'
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id])
  end

  def set_invoice
    @invoice = @appointment.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:total_amount, :payment_status)
  end
end
