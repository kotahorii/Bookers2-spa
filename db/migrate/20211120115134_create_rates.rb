class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.float :rate, default: 0
      t.timestamps
    end
  end
end
