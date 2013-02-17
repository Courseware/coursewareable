Fabricator('coursewareable/membership') do
  user(:fabricator => 'coursewareable/user')
  classroom(:fabricator => 'coursewareable/classroom')
  email_announcement { {
    :grade => "true",
    :announce => "true",
    :collaboration => "true",
    :generic => "true",
    :membership => "true" }.to_s }
end
