FactoryGirl.define do
  factory :user do
    email 'example@email.com'
    password 'password'
    password_confirmation 'password'
  end

  factory :url do
    original 'http://somewhere.com/and/further?q=a'
    short 'abc'
    description 'Description'
    user_id nil
  end
end
