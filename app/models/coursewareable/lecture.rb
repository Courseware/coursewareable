require 'friendly_id'
require 'sanitize'

module Coursewareable
  # [Classroom] lecture
  class Lecture < ActiveRecord::Base
    extend FriendlyId
    include PublicActivity::Model

    attr_accessible :content, :requisite, :title, :parent_lecture_id

    # Relationships
    belongs_to :parent_lecture, :class_name => Lecture
    belongs_to :user
    belongs_to :classroom
    has_many :images, :as => :assetable, :class_name => Image
    has_many :uploads, :as => :assetable, :class_name => Upload
    has_many :assignments, :dependent => :destroy
    has_many :responses, :through => :assignments
    has_many :grades, :through => :assignments
    has_many(:child_lectures, :class_name => Lecture,
             :foreign_key => :parent_lecture_id)

    # Validations
    validates_presence_of :title, :slug, :content

    # Generate title slug
    friendly_id :title, :use => :scoped, :scope => :classroom_id

    # Track activities
    tracked(:owner => :user, :recipient => :classroom, :params => {
      :user_name => proc {|c, m| m.user.name}
    }, :only => [:create])

    # Callbacks
    # Cleanup title and description before saving it
    before_validation do
      self.title = Sanitize.clean(self.title)
      self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
      self.requisite = Sanitize.clean(
        self.requisite, Sanitize::Config::RESTRICTED)
    end
  end
end
