module ApplicationHelper
  # Format currency in Vietnamese Dong
  def format_vnd(amount)
    number_to_currency(amount, unit: "VND", format: "%u %n", precision: 0)
  end

  # Format date in Vietnamese
  def format_date_vn(date)
    return "" if date.blank?
    date.strftime("%d/%m/%Y")
  end

  # Format datetime in Vietnamese
  def format_datetime_vn(datetime)
    return "" if datetime.blank?
    datetime.strftime("%d/%m/%Y %H:%M")
  end

  # Format time in Vietnamese
  def format_time_vn(time)
    return "" if time.blank?
    time.strftime("%H:%M")
  end

  # Check if navigation link is active
  def nav_link_active?(controller_name, action_name = "index")
    current_controller = controller.controller_name
    current_action = controller.action_name

    if controller_name == "home" && current_controller == "home" && current_action == "index"
      true
    elsif controller_name == current_controller && (action_name == "index" || action_name == current_action)
      true
    else
      false
    end
  end

  # Get status badge class
  def status_badge_class(status)
    case status
    when "scheduled", "pending"
      "badge bg-warning"
    when "in_progress"
      "badge bg-info"
    when "completed", "paid"
      "badge bg-success"
    when "cancelled"
      "badge bg-danger"
    else
      "badge bg-secondary"
    end
  end

  # Get gender display text
  def gender_display(gender)
    case gender
    when "male"
      "Đực"
    when "female"
      "Cái"
    else
      "Không xác định"
    end
  end

  # Get appointment type display text
  def appointment_type_display(type)
    case type
    when "consultation"
      "Tư vấn"
    when "vaccination"
      "Tiêm chủng"
    when "surgery"
      "Phẫu thuật"
    when "checkup"
      "Khám bệnh"
    else
      type.to_s.humanize
    end
  end

  # Get transaction type display text
  def transaction_type_display(type)
    case type
    when "IN"
      "Nhập kho"
    when "OUT"
      "Xuất kho"
    else
      type.to_s.humanize
    end
  end

  # Check if stock is low
  def low_stock_warning?(product)
    product.stock <= 10
  end

  # Get stock status class
  def stock_status_class(product)
    if product.stock == 0
      "text-danger"
    elsif low_stock_warning?(product)
      "text-warning"
    else
      "text-success"
    end
  end

  # Generate barcode image tag
  def barcode_image_tag(product, height: 50)
    image_tag product_barcode_path(product),
              alt: "Barcode: #{product.barcode}",
              height: height,
              class: "barcode-image"
  end

  # Format phone number
  def format_phone(phone)
    return phone if phone.blank?

    # Remove all non-digit characters
    digits = phone.gsub(/\D/, "")

    case digits.length
    when 10
      "#{digits[0..2]} #{digits[3..5]} #{digits[6..9]}"
    when 11
      "#{digits[0..3]} #{digits[4..6]} #{digits[7..10]}"
    else
      phone
    end
  end

  # Get breadcrumb items
  def breadcrumb_items
    items = []

    if controller_name == "owners"
      items << { text: "Chủ nuôi", path: owners_path }
      if action_name != "index"
        items << { text: @owner&.name || "Mới", path: @owner }
      end
    elsif controller_name == "patients"
      items << { text: "Chủ nuôi", path: owners_path }
      items << { text: @owner&.name, path: @owner }
      items << { text: "Bệnh nhân", path: owner_patients_path(@owner) }
      if action_name != "index"
        items << { text: @patient&.name || "Mới", path: [ @owner, @patient ] }
      end
    elsif controller_name == "appointments"
      items << { text: "Chủ nuôi", path: owners_path }
      items << { text: @patient&.owner&.name, path: @patient&.owner }
      items << { text: @patient&.name, path: [ @patient&.owner, @patient ] }
      items << { text: "Lịch hẹn", path: owner_patient_appointments_path(@patient&.owner, @patient) }
      if action_name != "index"
        items << { text: @appointment&.display_type || "Mới", path: [ @patient&.owner, @patient, @appointment ] }
      end
    elsif controller_name == "invoices"
      items << { text: "Chủ nuôi", path: owners_path }
      items << { text: @appointment&.patient&.owner&.name, path: @appointment&.patient&.owner }
      items << { text: @appointment&.patient&.name, path: [ @appointment&.patient&.owner, @appointment&.patient ] }
      items << { text: "Lịch hẹn", path: [ @appointment&.patient&.owner, @appointment&.patient, @appointment ] }
      items << { text: "Hóa đơn", path: owner_patient_appointment_invoices_path(@appointment&.patient&.owner, @appointment&.patient, @appointment) }
      if action_name != "index"
        items << { text: "Hóa đơn ##{@invoice&.id&.last(8)}" || "Mới", path: [ @appointment&.patient&.owner, @appointment&.patient, @appointment, @invoice ] }
      end
    elsif controller_name == "products"
      items << { text: "Sản phẩm", path: products_path }
      if action_name != "index"
        items << { text: @product&.name || "Mới", path: @product }
      end
    end

    items
  end
end
