require 'spec_helper'
require "paperclip/matchers"

describe Coursewareable::Image do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should validate_attachment_content_type(:attachment)
              .allowing(Coursewareable::Image::ALLOWED_TYPES)
              .rejecting('text/plain')
  }
  it { should belong_to(:user) }
  it { should belong_to(:classroom) }
  it { should belong_to(:assetable) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:classroom) }
  it { should validate_presence_of(:assetable) }

  context 'sanitization' do
    it 'should not allow html' do
      bad_input = Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>
      '

      image = Fabricate.build('coursewareable/image', :description => bad_input)
      image.description.should_not match(/\<\>/)
    end
  end
end
