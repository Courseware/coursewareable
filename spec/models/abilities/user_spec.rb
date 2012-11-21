require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for user' do
      let(:user){ Fabricate(:confirmed_user) }

      it{ should_not be_able_to(:create, Coursewareable::User) }
      it{ should_not be_able_to(:manage, Fabricate('coursewareable/user')) }
      it{ should be_able_to(:manage, user) }

      it{ should be_able_to(:create, Coursewareable::Classroom) }
      it{ should_not be_able_to(:update, Fabricate('coursewareable/classroom')) }
      it{ should_not be_able_to(:destroy, Fabricate('coursewareable/classroom')) }
      it{ should_not be_able_to(:dashboard, Fabricate('coursewareable/classroom')) }
      it{ should be_able_to(:update, Fabricate('coursewareable/classroom', :owner => user)) }
      it{ should be_able_to(:destroy, Fabricate('coursewareable/classroom', :owner => user)) }
      it{ should be_able_to(:dashboard, Fabricate('coursewareable/classroom', :owner => user))}

      it{ should_not be_able_to(:create, Fabricate.build('coursewareable/membership')) }
      it{ should_not be_able_to(:create, Coursewareable::Collaboration) }
      it{ should_not be_able_to(:destroy, Fabricate('coursewareable/membership')) }
      it{ should_not be_able_to(:destroy, Fabricate('coursewareable/collaboration')) }

      context 'with plan limits reached' do
        let(:user){ Fabricate('coursewareable/classroom').owner.reload }
        it{ should_not be_able_to(:create, Coursewareable::Classroom ) }
      end

      context 'with plan allowing collaborators' do
        before{ user.plan.increment!(:allowed_collaborators)}
        it{ should be_able_to(:create, Coursewareable::Collaboration) }
      end

    end
  end

end
