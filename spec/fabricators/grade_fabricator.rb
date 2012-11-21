Fabricator('coursewareable/grade') do
  form        :number
  mark        { rand(1..10) }
  comment     Faker::HTMLIpsum.body
  user(:fabricator => 'coursewareable/user')
  classroom   { |attr| Fabricate(
    'coursewareable/classroom', :owner => attr[:user]) }
  assignment  { |attr| Fabricate('coursewareable/assignment',
    :user => attr[:user], :classroom => attr[:classroom]) }
  receiver    { |attr| Fabricate(
    'coursewareable/membership', :classroom => attr[:classroom]).user }
end
