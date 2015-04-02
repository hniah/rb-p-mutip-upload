class Product < ActiveRecord::Base
  has_many :images
  attr_accessor :product_images
  validates  :product_images, presence: true
  validates  :name, presence: true
  validates  :description, presence: true

  def move_image(id, pid)
    image = ImageTemp.find(id)
    unless image.present?
      return
    end

    Image.create(picture_file_name: image.picture_file_name, picture_content_type: image.picture_content_type,
                 picture_file_size: image.picture_file_size, picture_updated_at: image.picture_updated_at, product_id:pid)

    s3 = AWS::S3.new
    styleImage = %w[original_ small_ thumb_ large_]
    styleImage.each do |style|
      paperclip_file_path = "public/images/products/#{pid}/#{id}/#{style+image.picture_file_name}"
      s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from("public/tmp/#{id}/#{style+image.picture_file_name}", acl: :public_read)
    end
    s3.buckets[Rails.configuration.aws[:bucket]].objects.with_prefix("public/images/tmp/#{id}/").delete_all
  end
end
