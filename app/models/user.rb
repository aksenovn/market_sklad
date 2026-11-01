class User < ApplicationRecord
  has_secure_password

  normalizes :name, with: ->(name) { name.strip }
  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :name,
            presence: { message: "Укажите имя" },
            length: {
              maximum: 100,
              message: "Имя не должно превышать 100 символов"
            }

  validates :email_address,
            presence: { message: "Укажите электронную почту" },
            uniqueness: { message: "Эта почта уже зарегистрирована" },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "Укажите корректную электронную почту"
            }

  validates :password,
            length: {
              minimum: 8,
              message: "Пароль должен содержать не менее 8 символов"
            },
            allow_nil: true

  validates :role, inclusion: { in: %w[ customer employee ] }

  def employee?
    role == "employee"
  end

  def customer?
    role == "customer"
  end
end
