Fabricator('coursewareable/invitation') do
  classroom(:fabricator => 'coursewareable/classroom')
  creator   { |attr| attr[:classroom].owner }
  email     { sequence(:invitation_email) { Faker::Internet.email } }
  role      { Coursewareable::Membership.name }
end
