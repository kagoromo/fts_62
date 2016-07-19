Admin.create!(
  name: "Admin",
  email: "admin@railstutorial.org",
  password: "12345678",
  password_confirmation: "12345678",
  chatwork_name: "11111111111111111111")

Admin.create!(
  name: "Admin",
  email: "admin1@railstutorial.org",
  password: "12345678",
  password_confirmation: "12345678",
  chatwork_name: "11111111111111111111")

Admin.create!(
  name: "Admin",
  email: "admin2@railstutorial.org",
  password: "12345678",
  password_confirmation: "12345678",
  chatwork_name: "11111111111111111111")

10.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "12345678"
  chatwork_name = "11111111111111111111"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    chatwork_name: chatwork_name)
end
