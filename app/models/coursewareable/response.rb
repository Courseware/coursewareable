require 'sanitize'

module Coursewareable
  # Coursewareable [Classroom] response
  class Response < ActiveRecord::Base
    include PublicActivity::Model

    attr_accessible :content

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

    # Track activities
    tracked :owner => :user, :recipient => :classroom

    # Callbacks
    # Cleanup title and description before saving it
    before_validation do
      self.content = Sanitize.clean(self.content, Sanitize::Config::RELAXED)
      self.coverage = self.coverage.to_f
    end
    before_save :process_answers

    # Evaluates answers against the questions
    def process_answers
      return if answers.blank?
      stats = { :all => 0, :wrong => 0 }

      result = assignment.quiz.each_with_index do |question, position|
        question['options'].each_with_index do |option, index|
          stats[:all] += 1
          if question['type'] == 'text'
            if(!self.answers[position]['options'][index]['answer'].match(
              /#{option['content']}/i))
              option['wrong'] = true
              stats[:wrong] +=1
            end
          elsif(option['valid'] == true and
                !self.answers[position]['options'][index]['answer'])
            option['wrong'] = true
            stats[:wrong] +=1
          elsif(!option['valid'] and
                self.answers[position]['options'][index]['answer'] and
                question['type'] != 'radios')
            option['wrong'] = true
            stats[:wrong] +=1
          end
        end
      end

      self.answers = result
      self.stats = stats
      self.coverage = ((stats[:all] - stats[:wrong]) * 100.0) / stats[:all]
    end #process_answers
  end
end
