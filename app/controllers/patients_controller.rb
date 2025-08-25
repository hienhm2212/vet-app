class PatientsController < ApplicationController
  before_action :set_owner
  before_action :set_patient, only: [ :show, :edit, :update, :destroy ]

  def index
    @patients = @owner.patients.order(:name)
  end

  def show
  end

  def new
    @patient = @owner.patients.build
  end

  def create
    @patient = @owner.patients.build(patient_params)

    if @patient.save
      redirect_to [ @owner, @patient ], notice: t("flash.patients.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @patient.update(patient_params)
      redirect_to [ @owner, @patient ], notice: t("flash.patients.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @patient.destroy
    redirect_to owner_patients_path(@owner), notice: t("flash.patients.destroyed")
  end

  private

  def set_owner
    @owner = Owner.find(params[:owner_id])
  end

  def set_patient
    @patient = @owner.patients.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:name, :species, :breed, :gender, :age, :weight, :notes)
  end
end
