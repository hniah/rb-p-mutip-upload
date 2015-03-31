class ImageTemp < ActiveRecord::Base

  PATH = '/public/tmp/:class/:id/:style_:basename.:extension'
  VALIDATE_SIZE = { in: 0..1.megabytes, message: 'Photo size too large. Please limit to 1 mb.' }
  has_attached_file :avatar,
                    styles: {small: '60x60#', thumb: '168x168#', large: '400x400#'},
                    path: PATH
  validates_attachment :avatar,
                       content_type: {content_type: /\Aimage\/.*\Z/},
                       size: VALIDATE_SIZE
end
