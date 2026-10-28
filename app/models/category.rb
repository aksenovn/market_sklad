class Category < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip }

  validates :name,
            presence: { message: "Укажите название категории" },
            uniqueness: { message: "Категория с таким названием уже существует" },
            length: {
              maximum: 100,
              message: "Название не должно превышать 100 символов"
            }
end
