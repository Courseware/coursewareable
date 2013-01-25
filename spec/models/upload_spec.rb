require 'spec_helper'
require "paperclip/matchers"

describe Coursewareable::Upload do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should belong_to(:user)}
  it { should belong_to(:classroom)}
  it { should belong_to(:assetable)}

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:classroom) }
  it { should validate_presence_of(:assetable) }

  context 'sanitization' do
    it 'should not allow html' do
      bad_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      file = Fabricate.build('coursewareable/upload', :description => bad_input)
      file.description.should_not match(/\<\>/)
    end
  end
end
