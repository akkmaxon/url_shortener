class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, exclusion: { in: ['', nil], message: 'Original URL can\'t be blank' }
  validates :short, presence: true
  validates :short, uniqueness: { case_sensitive: false }
end
