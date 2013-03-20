Fabricator('coursewareable/authentication') do
  user(:fabricator => 'coursewareable/user')
  provider  :facebook
  uid       { sequence(:uid){ |uid| uid } }
end
