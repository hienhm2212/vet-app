class InventoryTransactionsController < ApplicationController
  before_action :set_inventory_transaction, only: [:show]

  # GET /inventory_transactions
  def index
    @inventory_transactions = InventoryTransaction.includes(:product)
                                                  .ordered
                                                  .limit(100)
  end

  # GET /inventory_transactions/1
  def show
  end

  private

  def set_inventory_transaction
    @inventory_transaction = InventoryTransaction.find(params[:id])
  end
end
