require 'spec_helper'

describe Coursewareable::Invitation do
  it { should belong_to(:classroom) }
  it { should belong_to(:creator) }
  it { should belong_to(:user) }

  Coursewareable::Invitation::ALLOWED_ROLES.each do |role|
    it { should allow_value(role).for(:role) }
  end

  context 'with all attributes' do
    subject{ Fabricate('coursewareable/invitation') }

    it { should validate_presence_of(:email) }
    it { should allow_value('stas+cw@nerd.ro').for(:email) }
    it { should validate_presence_of(:creator) }

    its(:creator) { should be_a(Coursewareable::User) }

    context 'generated activity parameters' do
      let(:activity) do
        subject.classroom.all_activities.where(
          :key => 'coursewareable_invitation.create').first
      end

      it 'parameters should not be empty' do
        activity.parameters[:user_name].should be_nil
        activity.parameters[:creator_name].should eq(subject.creator.name)
      end

      context 'and invitation was updated' do
        before do
          subject.update_attributes(
            {:user_id => Fabricate('coursewareable/user').id})
        end
        let(:activity) do
          subject.classroom.all_activities.where(
            :key => 'coursewareable_invitation.update').first
        end

        it 'parameters should not be empty' do
          activity.parameters[:user_name].should eq(subject.user.name)
          activity.parameters[:creator_name].should eq(subject.creator.name)
        end
      end
    end
  end

  context 'is redeemable by an user' do
    let(:invitation) do
      Fabricate('coursewareable/invitation')
    end

    it 'updates attributes' do
      user = Fabricate(:confirmed_user, :email => invitation.email)
      user.invitations.should include(invitation)
    end
  end

  context 'is redeemable by a member' do
    let(:invitation) do
      Fabricate(:membership_invitation)
    end

    it 'updates attributes' do
      user = Fabricate(:confirmed_user, :email => invitation.email)
      user.invitations.should include(invitation)
      invitation.reload.user.reload.should eq(user)
      invitation.classroom.members.should include(user)
    end
  end

  context 'is redeemable by a collaborator' do
    let(:invitation) do
      Fabricate(:collaborator_invitation)
    end

    it 'updates attributes' do
      user = Fabricate(:confirmed_user, :email => invitation.email)
      user.invitations.should include(invitation)
      invitation.reload.user.should eq(user)
      invitation.classroom.collaborators.should include(user)
    end
  end
end
