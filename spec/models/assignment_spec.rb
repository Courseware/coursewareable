require 'spec_helper'

describe Coursewareable::Assignment do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:lecture) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_many(:responses).dependent(:destroy) }
  it { should have_many(:grades).dependent(:destroy) }

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/assignment') }

    it { should validate_uniqueness_of(:title).scoped_to(:classroom_id) }
    it { should respond_to(:slug) }
    it { should respond_to(:quiz) }

    it 'generates a new activity' do
      subject.user.activities_as_owner.collect(&:key).should(
        include('coursewareable_assignment.create'))
      subject.user.activities_as_owner.collect(&:recipient).should(
        include(subject.classroom)
      )
    end

    context 'generated activity parameters' do
      let(:activity) do
        subject.classroom.all_activities.where(
          :key => 'coursewareable_assignment.create').first
      end

      it 'parameters should not be empty' do
        activity.parameters[:user_name].should eq(subject.user.name)
        activity.parameters[:classroom_title].should eq(subject.classroom.title)
      end
    end
  end

  describe 'sanitization' do
    it 'allows no html' do
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

      assignment = Fabricate('coursewareable/assignment',
        :title => bad_input,
        :content => bad_long_input
      )
      assignment.title.should_not match(/\<\>/)
      assignment.content.should_not match(/\<(script|iframe)\>/)
    end
  end

  describe 'quiz' do
    let(:quiz_data) {
      [{ :content => Faker::Lorem.sentence, :type => :radios, :options => [
        { :content => Faker::Lorem.word, :valid => true },
        { :content => Faker::Lorem.word, :valid => false }]
      }]
    }

    it 'should properly handle quiz attributes' do
      assignment = Fabricate('coursewareable/assignment', :quiz => quiz_data)

      assignment.reload
      assignment.quiz.size.should eq(1)
      assignment.quiz.first.should_not be_empty
      assignment.quiz.first['type'].should eq('radios')
      assignment.quiz.first['options'].first['valid'].should be_true
    end

    it 'serializes properly attributes' do
      assignment = Fabricate('coursewareable/assignment',
                             :quiz => quiz_data.to_json)

      assignment.reload
      assignment.quiz.size.should eq(1)
      assignment.quiz.first.should_not be_empty
      assignment.quiz.first['type'].should eq('radios')
      assignment.quiz.first['options'].first['valid'].should be_true
    end

    it 'handles invalid data properly' do
      assignment = Fabricate('coursewareable/assignment',
                             :quiz => 'test')

      assignment.reload
      assignment.quiz.should be_nil
    end
  end
end
