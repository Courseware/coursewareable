require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for classroom lecture' do
      let(:lecture){ Fabricate('coursewareable/lecture') }

      context 'and a visitor' do
        let(:user){ Coursewareable::User.new }

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/lecture', :user => user,
          :classroom => lecture.classroom))
        }
        it{ should_not be_able_to(:manage, lecture) }
        it{ should_not be_able_to(:show, lecture) }
        it{ should_not be_able_to(:index, lecture) }
      end

      context 'and a member' do
        let(:user){ Fabricate('coursewareable/user') }
        before do
          classroom = lecture.classroom
          classroom.members << user
          classroom.save
        end

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/lecture', :user => user,
          :classroom => lecture.classroom))
        }
        it{ should_not be_able_to(:manage, lecture) }
        it{ should be_able_to(:read, lecture) }
        it{ should be_able_to(:index, lecture) }
      end

      context 'and a collaborator' do
        let(:user){ Fabricate('coursewareable/user') }
        before do
          classroom = lecture.classroom
          classroom.collaborators << user
          classroom.save
        end

        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/lecture', :user => user,
          :classroom => lecture.classroom))
        }
        it{ should be_able_to(:manage, lecture) }
      end

      context 'and a non-member' do
        let(:user){ Fabricate('coursewareable/user') }

        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/lecture', :user => user,
          :classroom => lecture.classroom))
        }
        it{ should_not be_able_to(:manage, lecture) }
        it{ should_not be_able_to(:show, lecture) }
        it{ should_not be_able_to(:index, lecture) }
      end
    end

  end
end
