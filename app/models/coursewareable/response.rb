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
      return if self.answers.blank?
      stats = { :all => 0, :wrong => 0 }

      result = assignment.quiz.each_with_index do |question, position|
        if question['type'] == 'radios'
          stats[:all] += 1
          valid_index = self.answers[position]['options']['answer'].to_i

          unless question['options'][valid_index]['valid']
            question['options'][valid_index]['wrong'] = true
            stats[:wrong] +=1
          end
        else
          question['options'].each_with_index do |option, index|
            stats[:all] += 1
            val = self.answers[position]['options'][index]['answer']

            if question['type'] == 'text' and
              !val.match(/#{option['content']}/i)
              option['wrong'] = true
              stats[:wrong] +=1
            elsif (option['valid'] == true and !val) or
              (!option['valid'] and val)
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
