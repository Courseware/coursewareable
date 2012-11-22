require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for classroom syllabus' do
      let(:syllabus){ Fabricate('coursewareable/syllabus') }

      context 'and a visitor' do
        let(:user){ Coursewareable::User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/syllabus', :user => user,
          :classroom => syllabus.classroom))
        }
        it{ should_not be_able_to(:manage, syllabus) }
        it{ should_not be_able_to(:show, syllabus) }
      end

      context 'and a member' do
        let(:user){ Fabricate('coursewareable/user') }
        before do
          classroom = syllabus.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/syllabus', :user => user,
          :classroom => syllabus.classroom))
        }
        it{ should_not be_able_to(:manage, syllabus) }
        it{ should be_able_to(:read, syllabus) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate('coursewareable/user') }
        before do
          classroom = syllabus.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/syllabus', :user => user,
          :classroom => syllabus.classroom))
        }
        it{ should be_able_to(:manage, syllabus) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate('coursewareable/user') }

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/syllabus', :user => user,
          :classroom => syllabus.classroom))
        }
        it{ should_not be_able_to(:manage, syllabus) }
        it{ should_not be_able_to(:show, syllabus) }
      end
    end

  end
end
