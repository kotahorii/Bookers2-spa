class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :introduction, :string, limit: 100
    remove_column :users, :nickname, :string
  end
end
