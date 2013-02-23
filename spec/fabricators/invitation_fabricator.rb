Fabricator('coursewareable/invitation') do
  classroom(:fabricator => 'coursewareable/classroom')
  creator   { |attr| attr[:classroom].owner }
  email     { sequence(:invitation_email) { Faker::Internet.email } }
end

Fabricator(:membership_invitation, :from => 'coursewareable/invitation') do
  classroom(:fabricator => 'coursewareable/classroom')
  creator   { |attr| attr[:classroom].owner }
  email     { sequence(:invitation_email) { Faker::Internet.email } }
  role      { Coursewareable::Membership.name }
end

Fabricator(:collaborator_invitation, :from => 'coursewareable/invitation') do
  classroom(:fabricator => 'coursewareable/classroom')
  creator   { |attr| attr[:classroom].owner }
  email     { sequence(:invitation_email) { Faker::Internet.email } }
  role      { Coursewareable::Collaboration.name }
end
