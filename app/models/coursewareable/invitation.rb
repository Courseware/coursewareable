module Coursewareable
  # Coursewareable [Classroom] invitations model
  class Invitation < ActiveRecord::Base
    include PublicActivity::Model

    attr_accessible :email, :role, :user_id

    # Relationships
    belongs_to :classroom
    belongs_to :creator, :class_name => User
    belongs_to :user

    # Validations
    validates_presence_of :email, :creator
    validates_format_of(
      :email, :with => Coursewareable::User::EMAIL_FORMAT, :on => :create)
    validates_inclusion_of(:role, :in => [
      # nil for non classroom related invitation, the other two for else
      nil, Coursewareable::Membership.name, Coursewareable::Collaboration.name])

    # Track activities
    tracked(:owner => :creator, :recipient => :classroom, :params => {
      :user_name => proc {|c, m| m.user.name if m.user},
      :creator_name => proc {|c, m| m.creator.name},
    }, :only => [:create, :update])
  end
end
