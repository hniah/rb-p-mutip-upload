class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :picture
      t.references :product
    end
  end
end
