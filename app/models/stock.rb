class Stock < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  before_destroy :ensure_empty

  validates :product_id,
            uniqueness: {
              scope: :warehouse_id,
              message: "Этот товар уже добавлен на выбранный склад"
            }

  validates :quantity, :reserved_quantity,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              message: "Количество должно быть целым неотрицательным числом"
            }

  validate :reserved_quantity_within_quantity

  def available_quantity
    quantity - reserved_quantity
  end

  private
  def ensure_empty
    return if quantity.zero? && reserved_quantity.zero?

    errors.add(:base, "Нельзя удалить запись с физическим остатком или резервом.")
    throw :abort
  end

  def reserved_quantity_within_quantity
    return unless quantity.is_a?(Integer) && reserved_quantity.is_a?(Integer)
    return if reserved_quantity <= quantity

    errors.add(
      :reserved_quantity,
      "Резерв не может превышать физическое количество"
    )
  end
end
