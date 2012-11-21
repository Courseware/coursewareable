require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for visitor' do
      let(:user){ Coursewareable::User.new }

      it{ should be_able_to(:create, Coursewareable::User) }
      it{ should_not be_able_to(:manage, Fabricate('coursewareable/user')) }

      it{ should_not be_able_to(:create, Coursewareable::Classroom) }
      it{ should_not be_able_to(:manage, Fabricate('coursewareable/classroom')) }
      it{ should_not be_able_to(:dashboard, Fabricate('coursewareable/classroom')) }

      it{ should_not be_able_to(:create, Coursewareable::Membership) }
      it{ should_not be_able_to(:create, Coursewareable::Collaboration) }
      it{ should_not be_able_to(:destroy, Fabricate('coursewareable/membership')) }
      it{ should_not be_able_to(:destroy, Fabricate('coursewareable/collaboration')) }

      it{ should_not be_able_to(:create, Coursewareable::Image) }
      it{ should_not be_able_to(:create, Coursewareable::Upload) }
      it{ should_not be_able_to(:manage, Fabricate('coursewareable/image')) }
      it{ should_not be_able_to(:manage, Fabricate('coursewareable/upload')) }
    end
  end
end
