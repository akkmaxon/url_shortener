class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, exclusion: { in: ['', nil], message: 'Original URL can\'t be blank' }

  DOMAIN = 'http://domain.com/'

  def create_short_link
    if short.empty?
      self.short = DOMAIN + id.to_s(36)
    else
      self.short = DOMAIN + self.short
    end
    self.save
  end
end
