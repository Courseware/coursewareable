require 'spec_helper'

describe Coursewareable::Membership do
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }

  context 'with all attributes' do
    let(:membership) { Fabricate('coursewareable/membership') }
    let!(:owner) { membership.classroom.owner }
    let!(:user_name) { membership.user.name }

    it 'should generate a new activity' do
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_membership.create')
      )
      owner.activities_as_owner.last.parameters[:user_name].should eq(user_name)
    end

    it 'should generate a new activity on deletion' do
      membership.destroy
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_membership.destroy')
      )
      owner.activities_as_owner.last.parameters[:user_name].should eq(user_name)
    end
  end
end
