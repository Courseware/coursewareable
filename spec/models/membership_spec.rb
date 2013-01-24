require 'spec_helper'

describe Coursewareable::Membership, :focus => true do
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }

  context 'with all attributes' do
    let(:membership) { Fabricate('coursewareable/membership') }
    let!(:owner) { membership.classroom.owner }

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
  end
end
