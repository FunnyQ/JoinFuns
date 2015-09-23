class ChangeMoneyColumnDefaultAtUserTable < ActiveRecord::Migration
  def change
    change_column :users, :money, :decimal, precision: 10, default: 0
  end
end
