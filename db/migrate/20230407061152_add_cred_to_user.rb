class AddCredToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :key, :string
    add_column :users, :secret, :string
  end
end
