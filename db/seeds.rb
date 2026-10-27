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