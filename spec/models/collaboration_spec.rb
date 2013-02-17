require 'spec_helper'

describe Coursewareable::Collaboration do
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }

  context 'with all attributes' do
    let(:collaboration) { Fabricate('coursewareable/collaboration') }
    let!(:owner) { collaboration.classroom.owner }
    let!(:user_name) { collaboration.user.name }

    it { should respond_to(:announce) }
    it { should respond_to(:collaboration) }
    it { should respond_to(:generic) }

    it 'should generate a new activity' do
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_collaboration.create')
      )
    end

    it 'should generate a new activity on deletion' do
      collaboration.destroy
      owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_collaboration.destroy')
      )
    end

    context 'generated activity parameters' do
      let(:activity) do
        collaboration.classroom.all_activities.where(
          :key => 'coursewareable_collaboration.create').first
      end

      it 'parameters should not be empty' do
        activity.parameters[:user_name].should eq(
          collaboration.creator.name)
        activity.parameters[:collaborator_name].should eq(
          collaboration.user.name)
        activity.parameters[:classroom_title].should eq(
          collaboration.classroom.title)
      end
    end
  end
end
