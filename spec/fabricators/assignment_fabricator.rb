Fabricator('coursewareable/assignment') do
  title         { sequence(:lecture_title){ Faker::Lorem.sentence } }
  content       Faker::HTMLIpsum.body
  user(:fabricator => 'coursewareable/user')
  classroom     { |attr|
    Fabricate('coursewareable/classroom', :owner => attr[:user]) }
  lecture       { |attr| Fabricate('coursewareable/lecture',
    :user => attr[:user], :classroom => attr[:classroom]) }
end
