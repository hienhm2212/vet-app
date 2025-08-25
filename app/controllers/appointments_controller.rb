class AppointmentsController < ApplicationController
  before_action :set_patient
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /owners/:owner_id/patients/:patient_id/appointments
  def index
    @appointments = @patient.appointments.ordered
  end

  # GET /owners/:owner_id/patients/:patient_id/appointments/1
  def show
  end

  # GET /owners/:owner_id/patients/:patient_id/appointments/new
  def new
    @appointment = @patient.appointments.build
  end

  # GET /owners/:owner_id/patients/:patient_id/appointments/1/edit
  def edit
  end

  # POST /owners/:owner_id/patients/:patient_id/appointments
  def create
    @appointment = @patient.appointments.build(appointment_params)

    if @appointment.save
      redirect_to [@patient.owner, @patient, @appointment], notice: t('flash.appointments.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /owners/:owner_id/patients/:patient_id/appointments/1
  def update
    if @appointment.update(appointment_params)
      redirect_to [@patient.owner, @patient, @appointment], notice: t('flash.appointments.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /owners/:owner_id/patients/:patient_id/appointments/1
  def destroy
    @appointment.destroy
    redirect_to owner_patient_appointments_url(@patient.owner, @patient), notice: t('flash.appointments.destroyed')
  end

  # PATCH /owners/:owner_id/patients/:patient_id/appointments/1/start
  def start
    @appointment = @patient.appointments.find(params[:id])
    if @appointment.update(status: 'in_progress')
      redirect_to [@patient.owner, @patient, @appointment], notice: 'Cuộc hẹn đã bắt đầu'
    else
      redirect_to [@patient.owner, @patient, @appointment], alert: 'Không thể bắt đầu cuộc hẹn'
    end
  end

  # PATCH /owners/:owner_id/patients/:patient_id/appointments/1/complete
  def complete
    @appointment = @patient.appointments.find(params[:id])
    if @appointment.update(status: 'completed')
      redirect_to [@patient.owner, @patient, @appointment], notice: 'Cuộc hẹn đã hoàn thành'
    else
      redirect_to [@patient.owner, @patient, @appointment], alert: 'Không thể hoàn thành cuộc hẹn'
    end
  end

  # PATCH /owners/:owner_id/patients/:patient_id/appointments/1/cancel
  def cancel
    @appointment = @patient.appointments.find(params[:id])
    if @appointment.update(status: 'cancelled')
      redirect_to [@patient.owner, @patient, @appointment], notice: 'Cuộc hẹn đã được hủy'
    else
      redirect_to [@patient.owner, @patient, @appointment], alert: 'Không thể hủy cuộc hẹn'
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_appointment
    @appointment = @patient.appointments.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:veterinarian_name, :scheduled_at, :appointment_type, :status)
  end
end
