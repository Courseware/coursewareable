# Many-to-many relationship between users and classrooms
module Coursewareable
  class Association < ActiveRecord::Base
    # Dynamic settings store
    store :email_announcement, :accessors => [
      :send_announcements, :send_generic, :send_grades]

    attr_accessible :send_announcements, :send_generic, :send_grades

    # Callbacks
    before_create do
      self.send_announcements = true if send_announcements.nil?
      self.send_generic = true if send_generic.nil?
      self.send_grades = true if send_grades.nil?
    end
  end
end
