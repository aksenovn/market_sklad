class SupplyItem < ApplicationRecord
  belongs_to :supply, inverse_of: :supply_items
  belongs_to :product

  validates :product_id,
            uniqueness: {
              scope: :supply_id,
              message: "Этот товар уже добавлен в поставку"
            }

  validates :quantity,
            numericality: {
              only_integer: true,
              greater_than: 0,
              message: "Количество должно быть целым числом больше нуля"
            }

  validates :purchase_price,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than: 10_000_000_000,
              message: "Закупочная цена должна быть от нуля до 10 миллиардов (не включая)"
            }
end
