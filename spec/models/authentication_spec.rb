require 'spec_helper'

describe Coursewareable::Authentication do
  it { should belong_to(:user) }

  describe 'with all attributes' do
    subject{ Fabricate('coursewareable/authentication') }

    it { should respond_to(:provider) }
    it { should respond_to(:uid) }
  end
end
