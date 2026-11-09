class Supplier < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip }
  normalizes :email, with: ->(email) { email.strip.downcase.presence }
  normalizes :phone, with: ->(phone) { phone.strip.presence }

  validates :name,
            presence: { message: "Укажите название поставщика" },
            uniqueness: { message: "Поставщик с таким названием уже существует" },
            length: { maximum: 100, message: "Название не должно превышать 100 символов" }

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Укажите корректную почту" },
            length: { maximum: 254, message: "Почта не должна превышать 254 символа" },
            allow_blank: true

  validates :phone,
            length: { maximum: 40, message: "Телефон не должен превышать 40 символов" },
            allow_blank: true
end
