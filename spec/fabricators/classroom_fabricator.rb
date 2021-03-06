Fabricator('coursewareable/classroom') do
  title       { sequence(:class_title){ Faker::Education.school[0..31] } }
  description Faker::Lorem.sentence
  owner(:fabricator => 'coursewareable/user')

  after_build { |classroom| classroom.owner.activate! }
end
