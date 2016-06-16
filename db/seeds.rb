MAX_USERS_COUNT = 10
MAX_URLS_PER_USER = 100

###Creating users
(1..MAX_USERS_COUNT).each do |n|
  username = Faker::Name.name
  password = 'password'
  User.create email: Faker::Internet.email(username),
    password: password,
    password_confirmation: password
end

###Creating urls
User.all.each do |user|
  urls_count = Url.count
  (1..MAX_URLS_PER_USER).each do |n|
    Url.create user: user,
      original: Faker::Internet.url,
      short: (urls_count + n).to_s(36),
      description: Faker::Lorem.paragraph
  end
end
