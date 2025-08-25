class AppointmentsController < ApplicationController
  before_action :set_patient
  before_action :set_appointment, only: [ :show, :edit, :update, :destroy ]

  def index
    @appointments = @patient.appointments.order(scheduled_at: :desc)
  end

  def show
  end

  def new
    @appointment = @patient.appointments.build
  end

  def create
    @appointment = @patient.appointments.build(appointment_params)

    if @appointment.save
      redirect_to [ @patient.owner, @patient, @appointment ], notice: t("flash.appointments.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to [ @patient.owner, @patient, @appointment ], notice: t("flash.appointments.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy
    redirect_to owner_patient_appointments_path(@patient.owner, @patient), notice: t("flash.appointments.destroyed")
  end

  def start
    @appointment = @patient.appointments.find(params[:id])
    if @appointment.update(status: "in_progress")
      redirect_to [ @patient.owner, @patient, @appointment ], notice: "Cuộc hẹn đã bắt đầu"
    else
      redirect_to [ @patient.owner, @patient, @appointment ], alert: "Không thể bắt đầu cuộc hẹn"
    end
  end

  def complete
    @appointment = @patient.appointments.find(params[:id])
    if @appointment.update(status: "completed")
      redirect_to [ @patient.owner, @patient, @appointment ], notice: "Cuộc hẹn đã hoàn thành"
    else
      redirect_to [ @patient.owner, @patient, @appointment ], alert: "Không thể hoàn thành cuộc hẹn"
    end
  end

  def cancel
    @appointment = @patient.appointments.find(params[:id])
    if @appointment.update(status: "cancelled")
      redirect_to [ @patient.owner, @patient, @appointment ], notice: "Cuộc hẹn đã được hủy"
    else
      redirect_to [ @patient.owner, @patient, @appointment ], alert: "Không thể hủy cuộc hẹn"
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
    params.require(:appointment).permit(:scheduled_at, :appointment_type, :notes, :status)
  end
end
