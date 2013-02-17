module Coursewareable
  # STI instance of [Association] to handle [Classroom] collaborations
  class Collaboration < Association
    include PublicActivity::Model

    belongs_to :user, :counter_cache => true
    belongs_to :classroom, :counter_cache => true

    # Dynamic settings store
    store :email_announcement, :accessors => [
      :announce, :collaboration, :generic]

    # Sugaring to avoid procs when tracking activities
    has_one :creator, :through => :classroom, :source => :owner

    # Track activities
    tracked(:owner => :creator, :recipient => :classroom, :params => {
      :user_name => proc {|c, m| m.creator.name},
      :collaborator_name => proc {|c, m| m.user.name},
      :classroom_title => proc {|c, m| m.classroom.title}
    }, :only => [:create, :destroy])
  end
end
