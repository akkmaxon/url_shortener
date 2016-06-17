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
    url = user.urls.build original: Faker::Internet.url,
      short: '',
      description: Faker::Lorem.paragraph
    url.generate_short_and_save
  end
  puts "User #{user.email} created with #{user.urls.count} urls" if Rails.env.development?
end
