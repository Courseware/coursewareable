require 'spec_helper'

describe Coursewareable::Collaboration, :focus => true do
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }

  context 'with all attributes' do
    let(:collaboration) { Fabricate('coursewareable/collaboration') }
    let!(:owner) { collaboration.classroom.owner }

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
  end
end
