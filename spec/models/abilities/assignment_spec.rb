require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for classroom assignment' do
      let(:assignment){ Fabricate('coursewareable/assignment') }

      context 'and a visitor' do
        let(:user){ Coursewareable::User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/assignment', :user => user,
          :classroom => assignment.classroom))
        }
        it{ should_not be_able_to(:manage, assignment) }
        it{ should_not be_able_to(:show, assignment) }
      end

      context 'and a member' do
        let(:user){ Fabricate('coursewareable/user') }
        before do
          classroom = assignment.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/assignment', :user => user,
          :classroom => assignment.classroom))
        }
        it{ should_not be_able_to(:manage, assignment) }
        it{ should be_able_to(:show, assignment) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate('coursewareable/user') }
        before do
          classroom = assignment.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/assignment', :user => user,
          :classroom => assignment.classroom))
        }
        it{ should be_able_to(:manage, assignment) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate('coursewareable/user') }

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/assignment', :user => user,
          :classroom => assignment.classroom))
        }
        it{ should_not be_able_to(:manage, assignment) }
        it{ should_not be_able_to(:show, assignment) }
      end
    end

  end
end
