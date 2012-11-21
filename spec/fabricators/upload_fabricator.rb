include ActionDispatch::TestProcess

Fabricator('coursewareable/upload') do
  description   { sequence(:upload){ Faker::HipsterIpsum.paragraph } }
  attachment    { fixture_file_upload('spec/fixtures/test.txt', 'text/plain') }
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
  assetable     { |attr| Fabricate('coursewareable/syllabus',
    :user => attr[:user], :classroom => attr[:classroom] ) }
end
