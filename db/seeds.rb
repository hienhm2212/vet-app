# Clear existing data
puts "Clearing existing data..."
Owner.destroy_all
Product.destroy_all

# Create sample owner
puts "Creating sample owner..."
owner = Owner.create!(
  name: "Nguyễn Văn An",
  phone: "0901234567",
  email: "nguyenvanan@email.com"
)

# Create sample patient (dog)
puts "Creating sample patient..."
patient = owner.patients.create!(
  name: "Lucky",
  species: "Chó",
  breed: "Golden Retriever",
  gender: "male",
  age: 3,
  weight: 25.5,
  notes: "Chó khỏe mạnh, thích chơi bóng"
)

# Create sample products
puts "Creating sample products..."
products = [
  {
    name: "Thức ăn cho chó Royal Canin",
    category: "Thức ăn",
    product_type: "Túi",
    price: 450000,
    stock: 50,
    supplier: "Công ty TNHH Royal Canin Việt Nam",
    barcode: "VN1234567890"
  },
  {
    name: "Thuốc tẩy giun Drontal",
    category: "Thuốc",
    product_type: "Viên",
    price: 85000,
    stock: 30,
    supplier: "Công ty Bayer Việt Nam",
    barcode: "VN0987654321"
  },
  {
    name: "Vaccine 5 bệnh cho chó",
    category: "Vaccine",
    product_type: "Chai",
    price: 120000,
    stock: 20,
    supplier: "Công ty Zoetis Việt Nam",
    barcode: "VN1122334455"
  },
  {
    name: "Dây xích da cao cấp",
    category: "Phụ kiện",
    product_type: "Cái",
    price: 180000,
    stock: 15,
    supplier: "Công ty Pet Shop Việt Nam",
    barcode: "VN5566778899"
  }
]

products.each do |product_attrs|
  Product.create!(product_attrs)
end

# Create sample appointment
puts "Creating sample appointment..."
appointment = patient.appointments.create!(
  veterinarian_name: "Bác sĩ Trần Thị Bình",
  scheduled_at: 1.day.from_now.at_beginning_of_hour + 9.hours, # 9:00 AM tomorrow
  appointment_type: "checkup",
  status: "scheduled"
)

# Create inventory transactions for initial stock
puts "Creating inventory transactions..."
Product.all.each do |product|
  InventoryTransaction.create!(
    product: product,
    quantity: product.stock,
    transaction_type: "IN",
    source: "Nhập hàng ban đầu"
  )
end

# Add products to invoice using barcode
puts "Adding products to invoice..."
invoice = appointment.invoice
product = Product.find_by(barcode: "VN1234567890") # Royal Canin food
invoice.add_product(product, 2) if product

product = Product.find_by(barcode: "VN0987654321") # Drontal medicine
invoice.add_product(product, 1) if product

puts "Seed data created successfully!"
puts "Sample data:"
puts "- Owner: #{owner.name} (#{owner.phone})"
puts "- Patient: #{patient.name} (#{patient.species} - #{patient.breed})"
puts "- Appointment: #{appointment.display_type} with #{appointment.veterinarian_name}"
puts "- Invoice total: #{invoice.total_amount.to_fs(:currency, unit: 'VND', format: '%u %n')}"
puts "- Products in stock: #{Product.count}"
puts "- Inventory transactions: #{InventoryTransaction.count}"
