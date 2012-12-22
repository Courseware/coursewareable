module Coursewareable
  # Generic uploaded file, STI from Asset
  class Upload < Asset
    has_attached_file :attachment
  end
end
