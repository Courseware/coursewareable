require 'spec_helper'

describe Coursewareable::Membership do
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }

  context 'with all attributes' do
    let(:membership) { Fabricate('coursewareable/membership') }
    let!(:owner) { membership.classroom.owner }
    let!(:user_name) { membership.user.name }

    it { should respond_to(:announce) }
    it { should respond_to(:membership) }
    it { should respond_to(:generic) }
    it { should respond_to(:grade) }

    it 'should generate a new activity' do
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_membership.create')
      )
    end

    it 'should generate a new activity on deletion' do
      membership.destroy
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_membership.destroy')
      )
    end

    context 'generated activity parameters' do
      let(:activity) do
        membership.classroom.all_activities.where(
          :key => 'coursewareable_membership.create').first
      end

      it 'parameters should not be empty' do
        activity.parameters[:user_name].should eq(membership.creator.name)
        activity.parameters[:member_name].should eq(membership.user.name)
        activity.parameters[:classroom_title].should eq(
          membership.classroom.title)
      end
    end

    it 'should have email announcement field' do
      membership.email_announcement.should_not be_nil
    end
  end
end
