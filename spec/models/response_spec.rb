require 'spec_helper'

describe Coursewareable::Response, :focus => true do
  it { should validate_presence_of(:content) }

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:assignment) }
  it { should have_many(:images) }
  it { should have_many(:uploads) }
  it { should have_one(:grade) }

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/response') }

    its(:answers) { should be_nil }
    its(:stats) { should be_nil }
    its(:coverage) { should eq(0.0) }

    it 'generates a new activity' do
      subject.user.activities_as_owner.collect(&:key).should(
        include('coursewareable_response.create'))
      subject.user.activities_as_owner.collect(&:recipient).should(
        include(subject.classroom)
      )
    end
  end

  describe 'sanitization' do
    let(:bad_long_input) { Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>'
    }

    subject { Coursewareable::Response.create(:content => bad_long_input) }

    its(:content) { should_not match(/\<(script|iframe)\>/) }
  end

  describe 'answers/coverage' do
    let(:assignment) { Fabricate(:assignment_with_quiz) }
    let(:resp) do
      Fabricate.build('coursewareable/response', :assignment => assignment,
        :answers => [
          # Text answer OK 1/1
          {'options' => [ {
            'answer' => assignment.quiz.first['options'].first['content'] } ] },
          # Checkboxes answer OK 2/2
          {'options' => [
            {'answer' => true }, {'answer' => false }, {'answer' => true } ] },
          # Radios answer OK 1/1
          {'options' => [
            {'answer' => true }, {'answer' => false }, {'answer' => false } ] }
        ]
      )
    end

    context 'all answers correct' do
      before { resp.save }

      subject { resp }

      its(:coverage) { should eq(100) }
      its(:stats) { should eq({:all => 7, :wrong => 0}) }
    end

    context 'text answer wrong' do
      before do
        resp.answers[0] = {'options' => [
          { 'answer' => Faker::Lorem.word + '_WRONG' } ] }
        resp.save
      end

      subject { resp }

      its(:coverage) { should eq(6 * 100.0 / 7) }
      its(:stats) { should eq({:all => 7, :wrong => 1}) }
      its(:answers) { subject.first['options'].first['wrong'].should be_true }
    end

    context 'checkbox answers mixed wrong' do
      before do
        resp.answers[1] = {'options' => [
          {'answer' => false }, {'answer' => true }, {'answer' => true } ] }
        resp.save
      end

      subject { resp }

      its(:coverage) { should eq(5 * 100.0 / 7) }
      its(:stats) { should eq({:all => 7, :wrong => 2}) }
      its(:answers) { subject[1]['options'][0]['wrong'].should be_true }
      its(:answers) { subject[1]['options'][1]['wrong'].should be_true }
    end

    context 'radio answers mixed wrong' do
      before do
        resp.answers[2] = {'options' => [
          {'answer' => false }, {'answer' => true }, {'answer' => false } ] }
        resp.save
      end

      subject { resp }

      its(:coverage) { should eq(6 * 100.0 / 7) }
      its(:stats) { should eq({:all => 7, :wrong => 1}) }
      its(:answers) { subject[2]['options'][0]['wrong'].should be_true }
    end

  end
end
