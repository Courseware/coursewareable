Fabricator('coursewareable/collaboration') do
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
  send_grades        true
  send_announcements true
  send_generic       false
end
