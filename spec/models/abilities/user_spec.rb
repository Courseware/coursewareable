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

      it{ should be_able_to(
        :create, Fabricate('coursewareable/classroom', :owner => user)) }
      it{ should_not be_able_to(
        :update, Fabricate('coursewareable/classroom')) }
      it{ should_not be_able_to(
        :destroy, Fabricate('coursewareable/classroom')) }
      it{ should_not be_able_to(
        :dashboard, Fabricate('coursewareable/classroom')) }
      it{ should be_able_to(
        :update, Fabricate('coursewareable/classroom', :owner => user)) }
      it{ should be_able_to(
        :destroy, Fabricate('coursewareable/classroom', :owner => user)) }
      it{ should be_able_to(
        :dashboard, Fabricate('coursewareable/classroom', :owner => user))}

      it{ should_not be_able_to(
        :create, Fabricate.build('coursewareable/membership')) }
      it{ should_not be_able_to(
        :create, Fabricate.build('coursewareable/collaboration')) }
      it{ should_not be_able_to(
        :destroy, Fabricate('coursewareable/membership')) }
      it{ should_not be_able_to(
        :destroy, Fabricate('coursewareable/collaboration')) }

      context 'when allowed classrooms limit is reached' do
        before { user.plan.decrement!(:allowed_classrooms, 100) }
        it{ should_not be_able_to(
          :create, Fabricate('coursewareable/classroom', :owner => user)) }
      end

      context 'with plan allowing collaborators' do
        let(:classroom) { Fabricate('coursewareable/classroom', :owner => user)}
        before{ user.plan.increment!(:allowed_collaborators)}

        it{ should be_able_to(:create, Fabricate.build(
          'coursewareable/collaboration', :classroom => classroom)) }
      end

    end
  end

end
