Fabricator('coursewareable/lecture') do
  title         { sequence(:lecture_title){ Faker::Lorem.sentence } }
  content       Faker::HTMLIpsum.body
  requisite     Faker::Lorem.paragraph
  user(:fabricator => 'coursewareable/user')
  classroom     { |attr| Fabricate(
    'coursewareable/classroom', :owner => attr[:user]) }
end
