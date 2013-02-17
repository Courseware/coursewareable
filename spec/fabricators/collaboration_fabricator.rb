Fabricator('coursewareable/collaboration') do
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
  announce      true
  collaboration true
  generic       true
end
