class RemoveColumnsFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :rate, :float, default: 0, null: false
  end
end
