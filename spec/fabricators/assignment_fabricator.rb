Fabricator('coursewareable/assignment') do
  title         { sequence(:lecture_title){ Faker::Lorem.sentence } }
  content       Faker::HTMLIpsum.body
  user(:fabricator => 'coursewareable/user')
  classroom     { |attr|
    Fabricate('coursewareable/classroom', :owner => attr[:user]) }
  lecture       { |attr| Fabricate('coursewareable/lecture',
    :user => attr[:user], :classroom => attr[:classroom]) }
end

Fabricator(:assignment_with_quiz, :from => 'coursewareable/assignment') do
  quiz { [
    { :content => Faker::Lorem.sentence, :type => :text, :options => [
      { :content => Faker::Lorem.word, :valid => true }],
    }.with_indifferent_access,
    { :content => Faker::Lorem.sentence, :type => :checkboxes, :options => [
      { :content => Faker::Lorem.word, :valid => true },
      { :content => Faker::Lorem.word, :valid => false },
      { :content => Faker::Lorem.word, :valid => true }]
    }.with_indifferent_access,
    { :content => Faker::Lorem.sentence, :type => :radios, :options => [
      { :content => Faker::Lorem.word, :valid => true },
      { :content => Faker::Lorem.word, :valid => false },
      { :content => Faker::Lorem.word, :valid => false }]
    }.with_indifferent_access,
  ] }
end
