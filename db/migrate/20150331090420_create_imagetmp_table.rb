class CreateImagetmpTable < ActiveRecord::Migration
  def change
    create_table :image_temps do |t|
      t.attachment :picture
    end
  end
end
