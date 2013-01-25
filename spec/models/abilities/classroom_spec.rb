require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for classroom' do
      let(:classroom){ Fabricate('coursewareable/classroom') }
      let(:user){ classroom.owner.reload }

      it{ should be_able_to(:dashboard, classroom)}
      it{ should be_able_to(:contribute, classroom)}

      context 'members' do
        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/membership', :classroom => classroom,
          :user => Fabricate('coursewareable/user'))) }
        it{ should be_able_to(:destroy, Fabricate(
          'coursewareable/membership', :classroom => classroom))}

        # Duplication
        it{ should_not be_able_to(:create, Fabricate.build(
          'coursewareable/membership',:user => user, :classroom => classroom))}
        # Remove himself
        it{ should_not be_able_to(:destroy, Fabricate(
          'coursewareable/membership',:user => user, :classroom => classroom))}
      end

      context 'collaborators' do
        before{ user.plan.increment!(:allowed_collaborators)}

        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/collaboration', :classroom => classroom,
          :user => Fabricate('coursewareable/user'))) }
        it{ should be_able_to(:destroy, Fabricate(
          'coursewareable/collaboration', :classroom => classroom))}

        context 'except duplications' do
          let!(:colab) do
            Fabricate('coursewareable/collaboration', :classroom => classroom)
          end

          it{ should_not be_able_to(:create, Fabricate.build(
            'coursewareable/collaboration',:user => colab.user,
            :classroom => classroom))}
        end
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
