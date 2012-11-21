Fabricator('coursewareable/user') do
  email       { sequence(:email) { Faker::Internet.email } }
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
  password    'secret'
end

Fabricator(:admin, :class_name => Coursewareable::User) do
  email       { sequence(:email) { Faker::Internet.email } }
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
  password    'secret'
  role        :admin
end

Fabricator(:confirmed_user, :class_name => Coursewareable::User) do
  email       { sequence(:email) { Faker::Internet.email } }
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
  password    'secret'
  after_create { |usr| usr.activate! }
end
