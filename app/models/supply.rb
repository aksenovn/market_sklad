class Supply < ApplicationRecord
  belongs_to :supplier
  belongs_to :warehouse
  has_many :supply_items, inverse_of: :supply, dependent: :destroy

  validates :status, inclusion: { in: %w[ draft received ] }

  def draft?
    status == "draft"
  end
    def receive!
    with_lock do
      next :already_received unless draft?

      items = supply_items.to_a
      next :empty if items.empty?

      items.sort_by(&:product_id).each do |item|
        stock = Stock.find_or_initialize_by(
          warehouse_id: warehouse_id,
          product_id: item.product_id
        )

        stock.quantity += item.quantity
        stock.save!
      end

      update!(status: "received")
      :received
    end
  end
end
