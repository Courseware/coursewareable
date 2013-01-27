require 'sanitize'

module Coursewareable
  # Coursewareable [Classroom] response
  class Response < ActiveRecord::Base
    include PublicActivity::Model

    attr_accessible :content, :answers

    # Dynamic quiz store
    store :quiz, :accessors => [:answers, :stats, :coverage]
    serialize :answers, JSON
    serialize :stats, HashWithIndifferentAccess

    # Relationships
    belongs_to :assignment
    belongs_to :user
    belongs_to :classroom

    has_many :images, :as => :assetable, :class_name => Image
    has_many :uploads, :as => :assetable, :class_name => Upload
    has_one :grade

    # Validations
    validates_presence_of :content
    validates_presence_of :assignment

    # Track activities
    tracked(:owner => :user, :recipient => :classroom, :params => {
      :user_name => proc {|c, m| m.user.name},
    }, :only => [:create])

    # Callbacks
    # Cleanup title and description before saving it
    before_validation do
      self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
      self.coverage = self.coverage.to_f
    end
    before_save :process_answers

    # Evaluates answers against the questions
    def process_answers
      return if assignment.quiz.blank?
      stats = { :all => 0, :wrong => 0 }

      result = assignment.quiz.each_with_index do |question, position|
        question['options'].each_with_index do |option, index|
          stats[:all] += 1 if option['valid'] == true
          begin
            val = self.answers[position.to_s]['options'][index.to_s]['answer']
          rescue
            if option['valid']
              option['wrong'] = true
              stats[:wrong] +=1
            end
            next
          end unless question['type'] == 'radios'

          if question['type'] == 'text' and !val.match(/#{option['content']}/i)
            option['wrong'] = true
            stats[:wrong] +=1
          elsif question['type'] == 'checkboxes' and
            (option['valid'] == true and !val) or (!option['valid'] and val)
            option['wrong'] = true
            stats[:wrong] +=1
          elsif question['type'] == 'radios'
            begin
              answer = self.answers[position.to_s]['options']['answer'].to_i
            rescue
              answer = -1
            end
            if option['valid'] == true and answer != index
              option['wrong'] = true
              stats[:wrong] +=1
            end
          end

        end
      end

      self.answers = result
      self.stats = stats
      self.coverage = ((stats[:all] - stats[:wrong]) * 100.0) / stats[:all]
    end #process_answers
  end
end
