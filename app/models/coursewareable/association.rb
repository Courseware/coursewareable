# Many-to-many relationship between users and classrooms
module Coursewareable
  # Coursewareable [Classroom] associations
  class Association < ActiveRecord::Base
    # Dynamic settings store
    store :email_announcement, :accessors => [
      :send_announcements, :send_generic, :send_grades]

    attr_accessible :send_announcements, :send_generic, :send_grades

    # Relationships
    belongs_to :classroom

    # Sugaring to avoid procs when tracking activities
    has_one :creator, :through => :classroom, :source => :owner

    # Callbacks
    before_create do
      self.send_announcements = true if send_announcements.nil?
      self.send_generic = true if send_generic.nil?
      self.send_grades = true if send_grades.nil?
    end
  end
end
