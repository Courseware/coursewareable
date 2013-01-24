module Coursewareable
  # STI instance of [Association] to handle [Classroom] memberships
  class Membership < Association
    include PublicActivity::Model

    belongs_to :user, :counter_cache => true
    belongs_to :classroom, :counter_cache => true

    # Sugaring to avoid procs when tracking activities
    has_one :creator, :through => :classroom, :source => :owner

    # Track activities
    tracked(:owner => :creator, :recipient => :classroom,
            :only => [:create, :destroy])
  end
end
