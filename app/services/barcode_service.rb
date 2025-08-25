class BarcodeService
  require "barby"
  require "barby/barcode/code_128"
  require "barby/outputter/png_outputter"

  def self.generate_barcode_png(barcode_text, height: 50, margin: 5)
    barcode = Barby::Code128.new(barcode_text)
    barcode.to_png(height: height, margin: margin)
  end

  def self.generate_product_barcode(product, height: 60, margin: 10)
    # Create barcode with product information
    # Format: barcode only (for scanning)
    barcode_text = product.barcode
    barcode = Barby::Code128.new(barcode_text)
    barcode.to_png(height: height, margin: margin)
  end

  def self.generate_thermal_barcode(product, height: 40, margin: 5)
    # Optimized for thermal printer - smaller size, minimal margins
    # Format: barcode only (for scanning)
    barcode_text = product.barcode
    barcode = Barby::Code128.new(barcode_text)
    barcode.to_png(height: height, margin: margin)
  end

  def self.generate_adhesive_label_barcode(product, height: 30, margin: 3)
    # Optimized for adhesive labels - compact size, minimal margins
    # Format: barcode only (for scanning)
    barcode_text = product.barcode
    barcode = Barby::Code128.new(barcode_text)
    barcode.to_png(height: height, margin: margin)
  end



  def self.generate_barcode_svg(barcode_text, height: 50, margin: 5)
    barcode = Barby::Code128.new(barcode_text)
    barcode.to_svg(height: height, margin: margin)
  end

  def self.generate_qr_code_png(text, size: 200)
    require "barby/barcode/qr_code"
    barcode = Barby::QrCode.new(text)
    barcode.to_png(size: size)
  end

  def self.validate_barcode(barcode_text)
    return false if barcode_text.blank?
    return false if barcode_text.length < 8 || barcode_text.length > 20

    # Check if barcode contains only alphanumeric characters
    barcode_text.match?(/\A[a-zA-Z0-9]+\z/)
  end

  def self.generate_unique_barcode(prefix: "VN")
    loop do
      # Generate a 10-digit random number
      random_number = SecureRandom.random_number(10**10).to_s.rjust(10, "0")
      barcode = "#{prefix}#{random_number}"

      # Check if barcode already exists
      unless Product.exists?(barcode: barcode)
        return barcode
      end
    end
  end

  def self.batch_generate_barcodes(count, prefix: "VN")
    barcodes = []
    count.times do
      barcodes << generate_unique_barcode(prefix: prefix)
    end
    barcodes
  end
end
