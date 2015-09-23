class ReviseLatLng < ActiveRecord::Migration
  def change
    change_column :events, :latitude, :decimal, :precision=>"20", :scale=>"10"
    change_column :events, :longitude, :decimal, :precision=>"20", :scale=>"10"
  end
end
