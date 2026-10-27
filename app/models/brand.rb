class Brand < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip }

  validates :name,
            presence: { message: "Укажите название бренда" },
            uniqueness: { message: "Бренд с таким названием уже существует" },
            length: {
              maximum: 100,
              message: "Название не должно превышать 100 символов"
            }
end
