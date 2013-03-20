module Coursewareable
  # Coursewareable [Authentication] class
  class Authentication < ActiveRecord::Base
    attr_accessible :user_id, :provider, :uid

    # Relationships
    belongs_to :user
  end
end
