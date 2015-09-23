class AddCityTalkPriceToEvent < ActiveRecord::Migration
  def change

    add_column :events , :citytalk_price , :string

  end
end
