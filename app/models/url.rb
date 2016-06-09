class Url < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  validates :original, presence: true
  validates :short, uniqueness: { case_sensitive: false }
end
