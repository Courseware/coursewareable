module Coursewareable
  # Coursewareable User model
  class User < ActiveRecord::Base
    include PublicActivity::Model

    # [User] email validation regex
    EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

    authenticates_with_sorcery!

    attr_accessible :email, :password, :password_confirmation,
      :first_name, :last_name, :description

    # Relationships
    has_many(
      :created_classrooms, :dependent => :destroy,
      :class_name => Classroom, :foreign_key => :owner_id
    )
    has_one :plan

    has_many :memberships, :dependent => :destroy
    has_many :collaborations, :dependent => :destroy
    has_many(:membership_classrooms,
             :through => :memberships, :source => :classroom)
    has_many(:collaboration_classrooms,
             :through => :collaborations, :source => :classroom)
    has_many :images
    has_many :uploads
    has_many :lectures
    has_many :assignments
    has_many :responses, :dependent => :destroy
    has_many :grades
    has_many(
      :received_grades, :dependent => :destroy,
      :foreign_key => :receiver_id, :class_name => Grade
    )

    # Validations
    validates_confirmation_of :password
    validates_presence_of :password, { on: :create }
    validates_length_of :password, :minimum => 6, :maximum => 32

    validates_presence_of :email
    validates_uniqueness_of :email
    validates_format_of :email, :with => EMAIL_FORMAT, :on => :create
    validates_length_of :description, :maximum => 1000

    # Enable public activity
    activist

    # Hooks
    before_create do |user|
      plan = Coursewareable.config.plans[:free]
      user.plan = Plan.create(plan.except(:cost))
    end
    # Cleanup description before saving it
    before_save do
      self.description = Sanitize.clean(
        self.description, Sanitize::Config::RESTRICTED)
    end

    # Helper to generate user's name
    def name
      return [first_name, last_name].join(' ') if first_name and last_name
      email
    end

    # Helper to fetch all classrooms related to user
    def classrooms
      return membership_classrooms + collaboration_classrooms
    end

    # Sugaring to count created collaborations across created classrooms
    def created_classrooms_collaborations_count
      created_classrooms.map(&:collaborations_count).reduce(:+).to_i
    end

  end
end
