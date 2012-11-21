require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for classroom' do
      let(:classroom){ Fabricate('coursewareable/classroom') }
      let(:user){ classroom.owner.reload }

      context 'members' do
        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/membership', :classroom => classroom,
          :user => Fabricate('coursewareable/user'))) }
        it{ should be_able_to(:destroy, Fabricate('coursewareable/membership',
                                                  :classroom => classroom))}
      end

      context 'collaborators' do
        before{ user.plan.increment!(:allowed_collaborators)}

        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/collaboration', :classroom => classroom,
          :user => Fabricate('coursewareable/user'))) }
        it{ should be_able_to(:destroy, Fabricate('coursewareable/collaboration',
                                                  :classroom => classroom))}
      end

      context 'lectures' do
        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/lecture', :user => user, :classroom => classroom))
        }
        it{ should be_able_to(:manage, Fabricate(
          'coursewareable/lecture', :user => user, :classroom => classroom)) }
      end

      context 'syllabuses' do
        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/syllabus', :user => user, :classroom => classroom))
        }
        it{ should be_able_to(:manage, Fabricate(
          'coursewareable/syllabus', :user => user, :classroom => classroom)) }
      end

      context 'assignments' do
        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/assignment', :user => user, :classroom => classroom))
        }
        it{ should be_able_to(:manage, Fabricate(
          'coursewareable/assignment', :user => user, :classroom => classroom)) }
      end
    end

  end
end
