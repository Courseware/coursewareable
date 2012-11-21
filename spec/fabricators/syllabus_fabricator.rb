Fabricator('coursewareable/syllabus') do
  title     { sequence(:syllabus_title){ Faker::Lorem.sentence } }
  content   Faker::HTMLIpsum.body
  intro     Faker::Lorem.paragraph
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
end
