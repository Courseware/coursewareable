require 'public_activity'
require 'paperclip'
require 'coursewareable/engine' if defined?(Rails)

module ::Coursewareable
  mattr_accessor :config
end
