class Product < ActiveRecord::Base
  has_many :images, dependent: :destroy
  attr_accessor :product_images
  validates  :product_images, presence: true
  validates  :name, presence: true
  validates  :description, presence: true

  def move_image(idt, pid)
    image = ImageTemp.find(idt)
    unless image.present?
      return
    end
   
    image = Image.create(picture_file_name: image.picture_file_name, picture_content_type: image.picture_content_type,
                 picture_file_size: image.picture_file_size, picture_updated_at: image.picture_updated_at, product_id:pid)

    s3 = AWS::S3.new
    folder_tmp= 'public/images/tmp/%{idt}/' % {idt: idt}
    styleImage = image.picture.styles.keys.push(:original)
    styleImage.each do |style|
      paperclip_file_path = 'public/images/products/%{iid}/%{style}_%{file_name}' % {iid: image.id, style: style, file_name: image.picture_file_name}
      img_temp = '%{folder_tmp}%{style}_%{file_name}' % {folder_tmp: folder_tmp, style: style, file_name: image.picture_file_name}
      s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(img_temp, acl: :public_read)
    end

    s3.buckets[Rails.configuration.aws[:bucket]].objects.with_prefix(folder_tmp).delete_all
  end
end
