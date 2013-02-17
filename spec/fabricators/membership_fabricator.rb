Fabricator('coursewareable/membership') do
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
  grade         true
  announce      true
  generic       true
  membership    true
end
