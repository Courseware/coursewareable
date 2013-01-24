require 'spec_helper'

describe Coursewareable::Collaboration do
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }

  context 'with all attributes' do
    let(:collaboration) { Fabricate('coursewareable/collaboration') }
    let!(:owner) { collaboration.classroom.owner }
    let!(:user_name) { collaboration.user.name }

    it 'should generate a new activity' do
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_collaboration.create')
      )
      owner.activities_as_owner.last.parameters[:user_name].should eq(user_name)
    end

    it 'should generate a new activity on deletion' do
      collaboration.destroy
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_collaboration.destroy')
      )
      owner.activities_as_owner.last.parameters[:user_name].should eq(user_name)
    end
  end
end
