require 'spec_helper'

describe Coursewareable::Association do
  context 'with all attributes' do
    subject do
      Coursewareable::Association.create
    end

    its(:send_announcements) { should be_true }
    its(:send_generic) { should be_true }
    its(:send_grades) { should be_true }
  end
end
