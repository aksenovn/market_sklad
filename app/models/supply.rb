class Supply < ApplicationRecord
  belongs_to :supplier
  belongs_to :warehouse
  has_many :supply_items, inverse_of: :supply, dependent: :destroy

  validates :status, inclusion: { in: %w[ draft received ] }

  def draft?
    status == "draft"
  end
end
