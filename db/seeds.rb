categories = {
  "Электроника" => "Смартфоны, аудиотехника и электронные устройства.",
  "Бытовая техника" => "Техника для кухни, уборки и ухода за домом.",
  "Компьютеры и аксессуары" => "Компьютеры, комплектующие и периферия.",
  "Товары для дома" => "Посуда, текстиль, декор и обустройство дома.",
  "Одежда и обувь" => "Одежда, обувь и повседневные аксессуары.",
  "Красота и уход" => "Косметика, средства гигиены и личного ухода.",
  "Спорт и отдых" => "Спортивный инвентарь и товары для отдыха.",
  "Детские товары" => "Игрушки и товары для детей."
}

categories.each do |name, description|
  category = Category.find_or_initialize_by(name: name)
  category.description = description
  category.save!
end
brand_names = [
  "Samsung",
  "Bosch",
  "Lenovo",
  "Xiaomi",
  "Philips",
  "Logitech",
  "Nike",
  "LEGO"
]

brand_names.each do |name|
  Brand.find_or_create_by!(name: name)
end

demo_products = [
  {
    sku: "SAM-DEMO-001",
    name: "Смартфон Samsung",
    description: "Демонстрационный смартфон для учебного каталога.",
    price: "29990.00",
    category_name: "Электроника",
    brand_name: "Samsung"
  },
  {
    sku: "BOS-DEMO-001",
    name: "Пылесос Bosch",
    description: "Демонстрационный пылесос для уборки дома.",
    price: "15990.00",
    category_name: "Бытовая техника",
    brand_name: "Bosch"
  },
  {
    sku: "LEN-DEMO-001",
    name: "Ноутбук Lenovo",
    description: "Демонстрационный ноутбук для учёбы и работы.",
    price: "59990.00",
    category_name: "Компьютеры и аксессуары",
    brand_name: "Lenovo"
  },
  {
    sku: "LEGO-DEMO-001",
    name: "Конструктор LEGO",
    description: "Демонстрационный набор конструктора.",
    price: "3990.00",
    category_name: "Детские товары",
    brand_name: "LEGO"
  }
]

demo_products.each do |attributes|
  product = Product.find_or_initialize_by(sku: attributes.fetch(:sku))

  next unless product.new_record?

  product.assign_attributes(
    name: attributes.fetch(:name),
    description: attributes.fetch(:description),
    price: attributes.fetch(:price),
    active: true,
    category: Category.find_by!(name: attributes.fetch(:category_name)),
    brand: Brand.find_by!(name: attributes.fetch(:brand_name))
  )

  product.save!
end
