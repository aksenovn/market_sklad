class Warehouse < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip }
  normalizes :address, with: ->(address) { address.strip }

  validates :name,
            presence: { message: "Укажите название склада" },
            uniqueness: { message: "Склад с таким названием уже существует" },
            length: {
              maximum: 100,
              message: "Название не должно превышать 100 символов"
            }

  validates :address,
            presence: { message: "Укажите адрес склада" },
            length: {
              maximum: 255,
              message: "Адрес не должен превышать 255 символов"
            }
end
