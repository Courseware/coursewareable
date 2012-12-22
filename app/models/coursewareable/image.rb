module Coursewareable
  # Image upload, STI from Asset
  class Image < Asset
    # List of allowed mime-types for image uploads
    ALLOWED_TYPES = %w( image/jpeg image/png image/gif image/pjpeg image/x-png )

    has_attached_file(
      :attachment, :styles => { :small => '200x150>', :large => '400x300>' }
    )

    # Validations
    validates_attachment_content_type :attachment, :content_type => ALLOWED_TYPES
  end
end
