require 'friendly_id'
require 'sanitize'

module Coursewareable
  # Coursewareable [Classroom] assignment
  class Assignment < ActiveRecord::Base
    extend FriendlyId
    include PublicActivity::Model

    attr_accessible :content, :title, :quiz

    # Serialize quiz values as a hash
    serialize :quiz, JSON

    # Relationships
    belongs_to :lecture
    belongs_to :user
    belongs_to :classroom

    has_many :images, :as => :assetable, :class_name => Image
    has_many :uploads, :as => :assetable, :class_name => Upload
    has_many :responses, :dependent => :destroy
    has_many :grades, :dependent => :destroy

    # Validations
    validates_presence_of :title, :slug, :content
    validates_uniqueness_of :title, :scope => :classroom_id

    # Generate title slug
    friendly_id :title, :use => :scoped, :scope => :classroom

    # Track activities
    tracked(:owner => :user, :recipient => :classroom, :params => {
      :user_name => proc {|c, m| m.user.name},
      :classroom_title => proc {|c, m| m.classroom.title}
    }, :only => [:create])

    # Callbacks
    # Cleanup title and description before saving it
    before_validation do
      self.title = Sanitize.clean(self.title)
      self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)

      # If quiz data was not deserialized, do it now
      if self.quiz.is_a?(String) and !self.quiz.blank?
        begin
          self.quiz = JSON.parse(self.quiz)
        rescue
          self.quiz = nil
        end
      end
    end
  end
end
