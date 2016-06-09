class User < ActiveRecord::Base
  has_many :urls
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
end
