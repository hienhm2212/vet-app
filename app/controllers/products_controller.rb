class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
    
    # Apply search filter
    @products = @products.search(params[:search]) if params[:search].present?
    
    # Apply category filter
    @products = @products.by_category(params[:category]) if params[:category].present?
    
    # Apply product type filter
    @products = @products.by_type(params[:product_type]) if params[:product_type].present?
    
    # Apply stock status filters
    if params[:stock_status] == 'low_stock'
      @products = @products.low_stock
    elsif params[:stock_status] == 'out_of_stock'
      @products = @products.where(stock: 0)
    elsif params[:stock_status] == 'in_stock'
      @products = @products.in_stock
    end
    
    # Apply price range filter
    if params[:price_min].present?
      @products = @products.where('price >= ?', params[:price_min])
    end
    
    if params[:price_max].present?
      @products = @products.where('price <= ?', params[:price_max])
    end
    
    # Apply sorting
    case params[:sort]
    when 'name'
      @products = @products.order(:name)
    when 'price_low'
      @products = @products.order(:price)
    when 'price_high'
      @products = @products.order(price: :desc)
    when 'stock_low'
      @products = @products.order(:stock)
    when 'stock_high'
      @products = @products.order(stock: :desc)
    when 'newest'
      @products = @products.order(created_at: :desc)
    else
      @products = @products.ordered
    end
    
    # Get filter options for the view
    @categories = Product.distinct.pluck(:category).compact.sort
    @product_types = Product.available_types
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: t('flash.products.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: t('flash.products.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: t('flash.products.destroyed')
  end

  # GET /products/1/barcode
  def barcode
    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.html do
        # Render the barcode view with product information
        render :barcode, layout: false
      end
      format.png do
        # Return adhesive label optimized barcode image
        send_data @product.generate_adhesive_label_barcode_png, type: 'image/png', disposition: 'inline'
      end
      format.all do
        # Default to HTML format
        render :barcode, layout: false
      end
    end
  end

  # GET /products/1/barcode_test
  def barcode_test
    @product = Product.find(params[:id])
    render :barcode_test, layout: false
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :category, :product_type, :price, :stock, :supplier, :barcode)
  end
end
