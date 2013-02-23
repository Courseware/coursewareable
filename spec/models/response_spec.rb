require 'spec_helper'

describe Coursewareable::Response do
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:assignment) }

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

    context 'generated activity parameters' do
      let(:activity) do
        subject.classroom.all_activities.where(
          :key => 'coursewareable_response.create').first
      end

      it 'parameters should not be empty' do
        activity.parameters[:user_name].should eq(subject.user.name)
      end
    end
  end

  describe 'sanitization' do
    let(:bad_long_input) { Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>'
    }

    subject { Fabricate('coursewareable/response', :content => bad_long_input)}

    its(:content) { should_not match(/\<(script|iframe)\>/) }
  end

  describe 'answers/coverage' do
    let(:assignment) { Fabricate(:assignment_with_quiz) }
    let(:resp) do
      Fabricate.build('coursewareable/response', :assignment => assignment,
        :answers => {
          # Text answer OK 1/1
          '0' => {'options' => { '0' => {
            'answer' => assignment.quiz.first['options'].first['content'] } } },
          # Checkboxes answer OK 2/2
          '1' => {'options' => { '0' => {'answer' => true },
                          '1' => {'answer' => false },
                          '2' => {'answer' => true } } },
          # Radios answer OK 1/1
          '2' => {'options' => {'answer' => 0 } }
        }
      )
    end

    context 'all answers correct' do
      before { resp.save }

      subject { resp }

      its(:coverage) { should eq(100) }
      its(:stats) { should eq({:all => 4, :wrong => 0}) }
    end

    context 'text answer wrong' do
      before do
        resp.answers['0'] = {'options' => { '0' =>
          { 'answer' => Faker::Lorem.word + '_WRONG' } } }
        resp.save
      end

      subject { resp }

      its(:coverage) { should eq(3 * 100.0 / 4) }
      its(:stats) { should eq({:all => 4, :wrong => 1}) }
      it { resp.answers[0]['options'][0]['wrong'].should be_true }
    end

    context 'checkbox answers mixed wrong' do
      before do
        resp.answers['1'] = {'options' => {
          '0' => {'answer' => false },
          '1' => {'answer' => true },
          '2' => {'answer' => true } } }
        resp.save
      end

      subject { resp }

      its(:coverage) { should eq(2 * 100.0 / 4) }
      its(:stats) { should eq({:all => 4, :wrong => 2}) }
      it { resp.answers[1]['options'][0]['wrong'].should be_true }
      it { resp.answers[1]['options'][1]['wrong'].should be_true }
    end

    context 'radio answers mixed wrong' do
      before do
        resp.answers['2'] = {'options' => {'answer' => 99 } }
        resp.save
      end

      subject { resp }

      its(:coverage) { should eq(3 * 100.0 / 4) }
      its(:stats) { should eq({:all => 4, :wrong => 1}) }
      it { resp.answers[2]['options'][0]['wrong'].should be_true }
    end

    context 'answers are missing' do
      before do
        resp.update_attribute(:answers, nil)
      end

      subject { resp }

      its(:coverage) { should eq(0 * 100.0 / 4) }
      its(:stats) { should eq({:all => 4, :wrong => 4}) }
      it { resp.answers[0]['options'][0]['wrong'].should be_true }
      it { resp.answers[1]['options'][0]['wrong'].should be_true }
      it { resp.answers[1]['options'][2]['wrong'].should be_true }
      it { resp.answers[2]['options'][0]['wrong'].should be_true }
    end

  end
end
