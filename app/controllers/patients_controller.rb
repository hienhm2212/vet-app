class PatientsController < ApplicationController
  before_action :set_owner
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /owners/:owner_id/patients
  def index
    @patients = @owner.patients.ordered
  end

  # GET /owners/:owner_id/patients/1
  def show
  end

  # GET /owners/:owner_id/patients/new
  def new
    @patient = @owner.patients.build
  end

  # GET /owners/:owner_id/patients/1/edit
  def edit
  end

  # POST /owners/:owner_id/patients
  def create
    @patient = @owner.patients.build(patient_params)

    if @patient.save
      redirect_to [@owner, @patient], notice: t('flash.patients.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /owners/:owner_id/patients/1
  def update
    if @patient.update(patient_params)
      redirect_to [@owner, @patient], notice: t('flash.patients.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /owners/:owner_id/patients/1
  def destroy
    @patient.destroy
    redirect_to owner_patients_url(@owner), notice: t('flash.patients.destroyed')
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
