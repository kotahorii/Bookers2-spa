class AddColumnsToRates < ActiveRecord::Migration[6.1]
  def change
    add_reference :rates, :user, null: false, foreign_key: true
    add_reference :rates, :book, null: false, foreign_key: true
  end
end
