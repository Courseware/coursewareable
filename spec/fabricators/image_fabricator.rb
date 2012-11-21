include ActionDispatch::TestProcess

Fabricator('coursewareable/image') do
  description   { sequence(:image){ Faker::HipsterIpsum.paragraph } }
  attachment    { fixture_file_upload(
    File.expand_path('../../fixtures/test.png', __FILE__), 'image/png' )}
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
  assetable     { |attr| Fabricate('coursewareable/syllabus',
    :user => attr[:user], :classroom => attr[:classroom] ) }
end
