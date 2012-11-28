require 'ostruct'

# Coursewareable configuration entries
Coursewareable.config = OpenStruct.new(
  :domain_blacklist => %w(blog api support help mail ftp dashboard),
  :plans => {
    :free => {
      :slug => :free,
      :allowed_classrooms => 1,
      :allowed_collaborators => 0,
      :allowed_space => 100.megabytes,
      :expires_in => nil,
      :cost => 0
    },
    :micro => {
      :slug => :micro,
      :allowed_classrooms => 5,
      :allowed_collaborators => 5,
      :allowed_space => 5.gigabytes,
      :expires_in => Time.now + 1.month,
      :cost => 7
    },
    :small => {
      :slug => :small,
      :allowed_classrooms => 10,
      :allowed_collaborators => 10,
      :allowed_space => 10.gigabytes,
      :expires_in => Time.now + 1.month,
      :cost => 12
    },
    :medium => {
      :slug => :medium,
      :allowed_classrooms => 20,
      :allowed_collaborators => 20,
      :allowed_space => 20.gigabytes,
      :expires_in => Time.now + 1.month,
      :cost => 22
    }
  }
) unless Coursewareable.config
