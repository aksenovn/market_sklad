class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand

  normalizes :name, with: ->(name) { name.strip }
  normalizes :sku, with: ->(sku) { sku.strip.upcase }
  before_save :update_search_text

  validates :name,
            presence: { message: "Укажите название товара" },
            length: {
              maximum: 150,
              message: "Название не должно превышать 150 символов"
            }

  validates :sku,
            presence: { message: "Укажите артикул" },
            uniqueness: { message: "Товар с таким артикулом уже существует" },
            length: {
              maximum: 50,
              message: "Артикул не должен превышать 50 символов"
            }

  validates :price,
            numericality: {
              greater_than: 0,
              less_than: 10_000_000_000,
              message: "Укажите цену больше нуля и меньше 10 миллиардов"
            }

  validates :active,
            inclusion: {
              in: [ true, false ],
              message: "Укажите активность товара"
            }
  private
  def update_search_text
    self.search_text = "#{name} #{sku}".downcase
  end
end
