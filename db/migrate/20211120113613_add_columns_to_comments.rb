class AddColumnsToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :rate, :float, default: 0, null: false
  end
end
