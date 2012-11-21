require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Coursewareable::Ability.new(user) }

    describe 'for admin' do
      let(:user){ Fabricate(:admin) }

      it{ should be_able_to(:create, Coursewareable::User) }
      it{ should be_able_to(:create, Coursewareable::Classroom) }
      it{ should be_able_to(:create, Coursewareable::Image) }
      it{ should be_able_to(:create, Coursewareable::Upload) }
      it{ should be_able_to(:create, Coursewareable::Lecture) }
      it{ should be_able_to(:create, Coursewareable::Membership) }
      it{ should be_able_to(:create, Coursewareable::Collaboration) }
      it{ should be_able_to(:create, Coursewareable::Syllabus) }
      it{ should be_able_to(:create, Coursewareable::Assignment) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/membership')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/collaboration')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/classroom')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/user')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/image')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/upload')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/lecture')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/syllabus')) }
      it{ should be_able_to(:manage, Fabricate('coursewareable/assignment')) }
    end
  end
end
