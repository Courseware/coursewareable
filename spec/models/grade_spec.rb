require 'spec_helper'

describe Coursewareable::Grade do
  it { should validate_presence_of(:mark) }
  it { should validate_presence_of(:form) }
  it { should validate_presence_of(:receiver) }

  Coursewareable::Grade::ALLOWED_FORMS.each do |form|
    it { should allow_value(form).for(:form) }
  end

  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:assignment) }
  it { should belong_to(:receiver) }
  it { should belong_to(:response) }

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/grade') }

    its(:form) { should eq('number') }
    its(:receiver) { should be_a(Coursewareable::User) }

    it 'should generate a new activity' do
      subject.user.activities_as_owner.collect(&:key).should include(
        'coursewareable_grade.create')
    end
  end

  describe 'receiver is the owner of the classroom' do
    let(:classroom) { Fabricate('coursewareable/classroom') }
    let(:receiver) { classroom.owner }
    let(:grade) {Fabricate.build('coursewareable/grade', :receiver => receiver)}

    subject { grade.save }

    it { should be_false }

    context 'or is not a member' do
      let(:receiver) { Fabricate('coursewareable/user') }
    end

    it { should be_false }
  end

  describe 'sanitization' do
    it 'should not allow html' do
      bad_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      grade = Coursewareable::Grade.create(
        :comment => bad_input
      )
      grade.comment.should_not match(/\<\>/)
    end
  end
end
