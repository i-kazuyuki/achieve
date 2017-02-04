100.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end

n = 1
while n <= 100
  Blog.create(
    title: Faker::Superhero.name,
    content: Faker::StarWars.quote,
    user_id: n
  )
  n = n + 1
end
