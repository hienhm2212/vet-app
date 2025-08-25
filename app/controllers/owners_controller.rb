class OwnersController < ApplicationController
  before_action :set_owner, only: [ :show, :edit, :update, :destroy ]

  def index
    @owners = Owner.search(params[:search]).ordered
  end

  def show
  end

  def new
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(owner_params)

    if @owner.save
      redirect_to @owner, notice: t("flash.owners.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @owner.update(owner_params)
      redirect_to @owner, notice: t("flash.owners.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @owner.destroy
    redirect_to owners_url, notice: t("flash.owners.destroyed")
  end

  private

  def set_owner
    @owner = Owner.find(params[:id])
  end

  def owner_params
    params.require(:owner).permit(:name, :phone, :email, :address)
  end
end
