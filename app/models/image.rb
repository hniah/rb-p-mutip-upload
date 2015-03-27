class Image < ActiveRecord::Base

  DEFAULT_URL = '/images/users/avatars/:style/missing.png'
  PATH = ':rails_root/public/:class/:attachment/:id/:style_:basename.:extension'
  VALIDATE_SIZE = { in: 0..1.megabytes, message: 'Photo size too large. Please limit to 1 mb.' }
  has_attached_file :avatar,
                    styles: {small: '60x60#', thumb: '168x168#', large: '400x400#'},
                    default_url: DEFAULT_URL,
                    path: PATH
  validates_attachment :avatar,
                       content_type: {content_type: /\Aimage\/.*\Z/},
                       size: VALIDATE_SIZE

end
