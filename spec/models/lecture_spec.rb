require 'spec_helper'

describe Coursewareable::Lecture do

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:parent_lecture) }
  it { should have_many(:child_lectures) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_many(:assignments).dependent(:destroy) }
  it { should have_many(:responses).through(:assignments) }
  it { should have_many(:grades).through(:assignments) }

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/lecture') }

    it { should respond_to(:slug) }

    its(:parent_lecture){ should be_nil }

    it 'should generate a new activity' do
      subject.user.activities_as_owner.collect(&:key).should include(
        'coursewareable_lecture.create')
      subject.user.activities_as_owner.collect(&:recipient).should(
        include(subject.classroom)
      )
    end

    context 'generated activity parameters' do
      let(:activity) do
        subject.classroom.all_activities.where(
          :key => 'coursewareable_lecture.create').first
      end

      it 'parameters should not be empty' do
        activity.parameters[:user_name].should eq(subject.user.name)
      end
    end
  end

  describe 'sanitization' do
    it 'should not allow html' do
      bad_input = '
      <h1>Heading</h1>
      <ol><li>Name</li></ol>
      <em>Content</em>
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '
      bad_long_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      lecture = Fabricate('coursewareable/lecture',
        :title => bad_input,
        :content => bad_long_input,
        :requisite => bad_input
      )
      lecture.title.should_not match(/\<\>/)
      lecture.content.should_not match(/\<(script|iframe)\>/)
      lecture.requisite.should_not match(/\<(script|iframe)\>/)
      lecture.requisite.should_not match(/\<(h1|li|ol)\>/)
    end
  end
end
