require 'sanitize'

module Coursewareable
  # Coursewareable [Classroom] grades
  class Grade < ActiveRecord::Base
    include PublicActivity::Model

    # Allowed grade forms
    ALLOWED_FORMS = ['number', 'percent', 'letter']

    attr_accessible :comment, :form, :mark, :receiver_id

    # Relationships
    belongs_to :receiver, :class_name => User
    belongs_to :assignment
    belongs_to :user
    belongs_to :classroom
    belongs_to :response

    # Validations
    validates_presence_of :mark, :form, :receiver
    validates_inclusion_of :form, :in => ALLOWED_FORMS

    # Track activities
    tracked :owner => :user, :recipient => :classroom

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
