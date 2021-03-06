require 'sanitize'

module Coursewareable
  # Coursewareable [Classroom] grades
  class Grade < ActiveRecord::Base
    include PublicActivity::Model

    # Allowed grade forms
    ALLOWED_FORMS = ['number', 'percent', 'letter']

    attr_accessible :comment, :form, :mark, :receiver_id, :response_id

    # Relationships
    belongs_to :receiver, :class_name => User
    belongs_to :assignment
    belongs_to :user
    belongs_to :classroom
    belongs_to :response

    # Validations
    validates_presence_of :mark, :form, :receiver
    validates_inclusion_of :form, :in => ALLOWED_FORMS
    validates_uniqueness_of :receiver_id, :scope => :assignment_id

    # Track activities
    tracked(:owner => :user, :recipient => :classroom, :params => {
      :user_name => proc {|c, m| m.user.name},
      :receiver_name => proc {|c, m| m.receiver.name},
      :classroom_title => proc {|c, m| m.classroom.title}
    }, :only => [:create, :update])

    # Callbacks
    # Cleanup title and description before saving it
    before_validation do
      self.comment = Sanitize.clean(self.comment)
    end

    before_save do
      return false if !classroom.members.include?(receiver) or
        classroom.owner.id == receiver_id
    end
  end
end
