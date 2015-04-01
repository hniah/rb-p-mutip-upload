class Image < ActiveRecord::Base
  belongs_to :product
  DEFAULT_URL = '/images/users/avatars/:style/missing.png'
  PATH = '/public/:class/product/:id/:style_:basename.:extension'
  VALIDATE_SIZE = { in: 0..1.megabytes, message: 'Photo size too large. Please limit to 1 mb.' }
  has_attached_file :picture,
                    styles: {small: '60x60#', thumb: '168x168#', large: '400x400#'},
                    default_url: DEFAULT_URL,
                    path: PATH
  validates_attachment :picture,
                       content_type: {content_type: /\Aimage\/.*\Z/},
                       size: VALIDATE_SIZE

  def perform(id)
    image = Image.find(id)
    s3 = AWS::S3.new

    paperclip_file_path = "public/images/avatars/#{id}/origin/thumb_#{image.avatar_file_name.to_s+Random.rand(1111).to_s}"
    s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from("public/images/product/#{id}/thumb_#{image.avatar_file_name}", acl: :public_read)

    #s3.buckets[Rails.configuration.aws[:bucket]].objects.with_prefix("public/images/avatars/#{id}/").delete_all
  end
end
