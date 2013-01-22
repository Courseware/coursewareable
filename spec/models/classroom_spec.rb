require 'spec_helper'

describe Coursewareable::Classroom do
  it { should belong_to(:owner) }
  it { should have_many(:memberships).dependent(:destroy) }
  it { should have_many(:members).through(:memberships) }
  it { should have_many(:collaborations).dependent(:destroy) }
  it { should have_many(:collaborators).through(:collaborations) }
  it { should have_many(:assets) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_many(:lectures) }
  it { should have_many(:assignments) }
  it { should have_many(:responses) }
  it { should have_many(:grades) }
  it { should have_one(:syllabus) }

  Coursewareable.config.domain_blacklist.each do |domain|
    it { should_not allow_value(domain).for(:slug) }
  end

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/classroom') }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:slug).is_at_least(4).is_at_most(32) }
    it { should validate_uniqueness_of(:slug) }

    it { should respond_to(:memberships_count) }
    it { should respond_to(:header_image) }
    it { should respond_to(:color) }
    it { should respond_to(:color_scheme) }

    its(:owner) { should be_a(Coursewareable::User) }
    its(:slug) { should match(/^[\w\-0-9]+$/) }

    it 'should generate a new activity' do
      subject.owner.activities_as_owner.collect(&:key).should(
        include('coursewareable_classroom.create')
      )
    end

    it 'should have the owner in memberships' do
      subject.members.should include(subject.owner)
    end
  end

  context 'sanitization' do
    context 'generates slug from title' do
      let(:title) { Faker::Lorem.sentence }
      before { subject.update_attributes({:title => title}) }

      its(:slug) { should eq(title.parameterize) }
    end

    context 'parameterizes slug' do
      let(:title) { Faker::Lorem.sentence }
      let(:slug) { Faker::Lorem.sentence }
      before { subject.update_attributes({:title => title, :slug => slug}) }

      its(:slug) { should eq(slug.parameterize) }

      context 'even if its blank' do
        let(:slug) { '' }
        its(:slug) { should eq(title.parameterize) }
      end
    end

    it 'should not allow html' do
      bad_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      classroom = Coursewareable::Classroom.create(
        :title => bad_input,
        :description => bad_input
      )
      classroom.title.should_not match(/\<\>/)
      classroom.description.should_not match(/\<(script|iframe)\>/)
      classroom.description.should_not match(/\<(h1|li|ol)\>/)
    end
  end

  describe '#all_activities' do
    it 'should query all available activities' do
      classroom = Fabricate('coursewareable/classroom')
      classroom.all_activities.count.should eq(1)

      Fabricate('coursewareable/syllabus', :classroom => classroom)
      classroom.all_activities.count.should eq(2)
    end
  end

end

