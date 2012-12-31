require 'friendly_id'
require 'sanitize'

module Coursewareable
  # Coursewareableable classroom model
  class Classroom < ActiveRecord::Base
    include PublicActivity::Model

    attr_accessible :description, :title, :slug

    # Dynamic settings store
    store :settings, :accessors => [:color_scheme, :header_image, :color]

    # Relationships
    belongs_to(
      :owner, :counter_cache => :created_classrooms_count, :class_name => User
    )

    has_many :memberships, :dependent => :destroy
    has_many :members, :through => :memberships, :source => :user
    has_many :collaborations, :dependent => :destroy
    has_many :collaborators, :through => :collaborations, :source => :user
    has_many :images
    has_many :uploads
    has_many :lectures
    has_many :assignments
    has_many :responses
    has_one :syllabus

    # Validations
    validates_presence_of :title, :description
    validates_uniqueness_of :slug, :case_sensitive => false
    validates_exclusion_of :slug, :in => Coursewareable.config.domain_blacklist
    validates_length_of :slug, :minimum => 4, :maximum => 32

    # Track activities
    tracked :owner => :owner, :only => [:create]

    # Callbacks
    # Cleanup title and description before saving it
    before_validation do
      self.title = Sanitize.clean(self.title)
      self.slug = (self.slug || self.title).parameterize
      self.description = Sanitize.clean(
        self.description, Sanitize::Config::RESTRICTED)
    end
    # When creating a new classroom, owner becomes a member too
    after_create do |classroom|
      classroom.members << classroom.owner
    end

    # Get all classroom activities
    def all_activities
      t = PublicActivity::Activity.arel_table
      PublicActivity::Activity.where(
        t[:trackable_id].eq(id).and(t[:trackable_type].eq(Classroom.to_s)).or(
          t[:recipient_id].eq(id).and(t[:recipient_type].eq(Classroom.to_s))
        )
      ).reverse_order
    end

  end
end
