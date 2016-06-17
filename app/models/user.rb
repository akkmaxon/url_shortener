class User < ActiveRecord::Base
  has_many :urls
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :omniauthable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = if auth.info.email then auth.info.email
		   elsif auth.info.nickname then "#{auth.info.nickname}@akkush.com"
		   elsif auth.info.name then "#{auth.info.name}@akkush.com"
		   end
      user.password = Devise.friendly_token[0,20]
    end
  end
end
