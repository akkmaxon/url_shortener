class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, :short, presence: true
  validates :short, uniqueness: { case_sensitive: false }
end
