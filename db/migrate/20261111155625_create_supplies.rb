class CreateSupplies < ActiveRecord::Migration[8.1]
  def change
    create_table :supplies do |t|
      t.references :supplier, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.string :status, null: false, default: "draft"
      t.text :notes

      t.timestamps

      t.check_constraint "status IN ('draft', 'received')",
                         name: "supplies_status_allowed"
    end
  end
end
