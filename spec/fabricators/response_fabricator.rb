Fabricator('coursewareable/response') do
  content       Faker::HTMLIpsum.body
  user(:fabricator => 'coursewareable/user')
  classroom     { |attr| Fabricate(
    'coursewareable/classroom', :owner => attr[:user]) }
  assignment    { |attr| Fabricate('coursewareable/assignment',
    :user => attr[:user], :classroom => attr[:classroom]) }
end
