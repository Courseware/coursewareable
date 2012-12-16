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

    its(:activities){ should_not be_empty }

    it 'should generate a new activity' do
      subject.user.activities.collect(&:key).should(
        include('coursewareable_assignment.create'))
      subject.user.activities.collect(&:recipient).should(
        include(subject.classroom)
      )
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

      assignment = Coursewareable::Assignment.create(
        :title => bad_input,
        :content => bad_long_input
      )
      assignment.title.should_not match(/\<\>/)
      assignment.content.should_not match(/\<(script|iframe)\>/)
    end
  end

  describe 'quiz' do
    it 'should properly serialize attributes' do
      assignment = Coursewareable::Assignment.create(
        :title => Faker::Lorem.sentence,
        :content => Faker::HTMLIpsum.body
      )

      assignment.quiz = [
        { :content => Faker::Lorem.sentence, :type => :radios, :options => [
          { :content => Faker::Lorem.word, :valid => true },
          { :content => Faker::Lorem.word, :valid => false }
        ]}
      ]

      assignment.save
      assignment.reload

      assignment.quiz.size.should eq(1)
      assignment.quiz.first.should_not be_empty
      assignment.quiz.first['type'].should eq('radios')
      assignment.quiz.first['options'].first['valid'].should be_true
    end
  end
end
