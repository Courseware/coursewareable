require 'cancan'

module Coursewareable
  # Coursewareable user abilities
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      @user = user || Coursewareable::User.new # guest user (not logged in)

      if @user.role == :admin
        admin_abilities
      else
        visitor_abilities

        # Allow nothing if not logged in
        return if @user.id.nil?

        ######################

        %w(user classroom membership collaboration assets syllabus lecture
          assignment response grade).each do |component|
          self.send("#{component}_abilities")
        end
      end
    end

    # [User] abilities with role :admin
    def admin_abilities
      can :manage, :all
    end

    # Visitor aka unknown [User] abilities
    def visitor_abilities
      # Can be created/activated if only visitor is not registered
      can :create, Coursewareable::User if @user.id.nil?
    end

    # [User] abilities with no role, aka ordinary user
    def user_abilities
      # Can be updated if only visitor owns it
      can :manage, Coursewareable::User, :id => @user.id

      # Can not create another user
      cannot :create, Coursewareable::User
    end

    # [Classroom] relevant abilities
    def classroom_abilities
      # Can manage a classroom if its the owner
      can [:update, :destroy], Coursewareable::Classroom, :owner_id => @user.id

      # Can access classroom if only a member
      can :dashboard, Coursewareable::Classroom do |classroom|
        classroom.members.include?(@user) or
          classroom.collaborators.include?(@user)
      end

      # Can contribute to the classroom if only an owner or collaborator
      can :contribute, Coursewareable::Classroom do |classroom|
        classroom.owner.eql?(@user) or classroom.collaborators.include?(@user)
      end

      # Can not create a classroom if plan limits reached
      can :create, Coursewareable::Classroom do |classroom|
        classroom.owner.created_classrooms_count <
        classroom.owner.plan.allowed_classrooms
      end
    end

    # [Classroom] [Membership] relevant abilities
    def membership_abilities
      # Can create own classroom memberships
      can :create, Coursewareable::Membership do |mem|
        mem.classroom.owner.eql?(@user) and
          !mem.classroom.members.include?(mem.user)
      end
      # Can remove own classroom membership if not owner membership
      can :destroy, Coursewareable::Membership do |mem|
        (mem.classroom.owner.eql?(@user) and !mem.user.eql?(@user)) or
          (mem.user.eql?(@user) and !mem.classroom.owner.eql?(@user))
      end
    end

    # [Classroom] [Collaboration] relevant abilities
    def collaboration_abilities
      # Can not add a classroom collaborator if limit reached
      can :create, Coursewareable::Collaboration do |col|
        col.classroom.owner.eql?(@user) and (
          @user.created_classrooms_collaborations_count <
            @user.plan.allowed_collaborators) and
              !col.classroom.collaborators.include?(col.user)
      end
      # Can remove own classroom collaboration
      can :destroy, Coursewareable::Collaboration do |col|
        col.user.eql?(@user) or col.classroom.owner.eql?(@user)
      end
    end

    # [Classroom] [Asset] relevant abilities, aka [Upload] and [Image]
    def assets_abilities
      # Can manage assets if user is the owner or collaborator
      can :index, Coursewareable::Asset do |asset|
        asset.classroom.collaborators.include?(@user) or
          asset.classroom.owner.eql?(@user)
      end
      # Can create assets if in the same classroom
      can :create, Coursewareable::Asset do |asset|
        asset.classroom.collaborators.include?(@user) or
          asset.classroom.members.include?(@user)
      end
      # Can destroy asset if user owns it or can manage classroom
      can :destroy, Coursewareable::Asset do |asset|
        asset.classroom.collaborators.include?(@user) or
          asset.classroom.owner.eql?(@user) or
          asset.user.eql?(@user)
      end
    end

    # [Classroom] [Syllabus] relevant abilities
    def syllabus_abilities
      # Can manage syllabus if user is the owner or collaborator
      can :manage, Coursewareable::Syllabus do |syl|
        syl.classroom.collaborators.include?(@user) or
          syl.classroom.owner.eql?(@user)
      end
      # Can access syllabus if user is a member of the classroom
      can :read, Coursewareable::Syllabus do |syl|
        syl.classroom.members.include?(@user)
      end
    end

    # [Classroom] [Lecture] relevant abilities
    def lecture_abilities
      # Can manage lectures if user is the owner or collaborator
      can :manage, Coursewareable::Lecture do |lecture|
        lecture.classroom.collaborators.include?(@user) or
          lecture.classroom.owner.eql?(@user)
      end
      # Can access lecture if user is a member of the classroom
      can :read, Coursewareable::Lecture do |lecture|
        lecture.classroom.members.include?(@user)
      end
    end

    # [Classroom] [Assignment] relevant abilities
    def assignment_abilities
      # Can manage assignment if user is the owner or collaborator
      can :manage, Coursewareable::Assignment do |assignment|
        assignment.classroom.collaborators.include?(@user) or
          assignment.classroom.owner.eql?(@user)
      end
      # Can access assignment if user is a member of the classroom
      can :read, Coursewareable::Assignment do |assignment|
        assignment.classroom.members.include?(@user)
      end
    end

    # [Classroom] [Response] relevant abilities
    def response_abilities
      # Can manage response if user is the owner or collaborator
      can :destroy, Coursewareable::Response do |resp|
        resp.classroom.collaborators.include?(@user) or
          resp.classroom.owner.eql?(@user)
      end
      # Can create response if user is a classroom member
      can :create, Coursewareable::Response do |resp|
        resp.classroom.members.include?(@user) and
          not resp.classroom.owner.eql?(@user)
      end
      # Can access response if user is a member of the classroom
      can :read, Coursewareable::Response do |resp|
        resp.classroom.collaborators.include?(@user) or
          resp.classroom.owner.eql?(@user) or
          resp.user.eql?(@user)
      end
    end

    # [Classroom] [Assignment] grades
    def grade_abilities
      can :manage, Coursewareable::Grade do |grade|
        grade.classroom.collaborators.include?(@user) or
          grade.classroom.owner.eql?(@user)
      end
    end
  end
end
