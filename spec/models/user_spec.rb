require 'spec_helper'
require 'cancan/matchers'

describe Coursewareable::User do

  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(32) }

  it { should validate_presence_of(:email) }
  it { should validate_format_of(:email).with('stas+cw@nerd.ro') }

  it { should ensure_length_of(:description).is_at_most(1000) }

  it { should have_one(:plan) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:collaborations).dependent(:destroy) }
  it { should have_many(:created_classrooms).dependent(:destroy) }
  it { should have_many(:membership_classrooms).through(:memberships) }
  it { should have_many(:collaboration_classrooms).through(:collaborations) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_many(:lectures) }
  it { should have_many(:assignments) }
  it { should have_many(:responses).dependent(:destroy) }
  it { should have_many(:grades) }
  it { should have_many(:received_grades).dependent(:destroy) }

  it { should respond_to(:created_classrooms_count) }
  it { should respond_to(:memberships_count) }

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/user') }

    it { should validate_uniqueness_of(:email) }

    its(:role) { should be_nil }
    its(:name) { should match(/\w?+ \w?+/) }
    its(:plan) { should be_a(Coursewareable::Plan) }
    its('plan.slug') { should eq(:free) }

    context 'sanitization' do
      let(:bad_input) do
        Faker::HTMLIpsum.body + '
          <script>alert("PWND")</script>
          <iframe src="http://pwnr.com/pwnd"></iframe>
        '
      end

      before do
        subject.update_attribute(:description, bad_input)
      end

      its(:description) { should_not match(/\<(script|iframe)\>/) }
      its(:description) { should_not match(/\<(h1|li|ol)\>/) }
    end
  end

  describe 'with no first/last name' do
    subject{
      Fabricate('coursewareable/user', :first_name => nil, :last_name => nil) }
    its(:name) { should match(/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/) }
  end

  describe '#classrooms' do
    subject { Fabricate('coursewareable/user') }
    let(:classroom_for_member) { Fabricate('coursewareable/classroom') }
    let(:classroom_for_collab) { Fabricate('coursewareable/classroom') }

    its(:classrooms) { should_not include(classroom_for_member) }
    its(:classrooms) { should_not include(classroom_for_collab) }

    context 'when added as collaborator' do
      before { classroom_for_collab.collaborators << subject }
      its(:classrooms) { should include(classroom_for_collab) }
    end

    context 'when added as collaborator' do
      before { classroom_for_member.members << subject }
      its(:classrooms) { should include(classroom_for_member) }
    end

  end

  describe 'with admin role and all attributes' do
    subject{ Fabricate(:admin) }

    its(:role) { should eq(:admin) }
  end

end
