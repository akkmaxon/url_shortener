class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, exclusion: { in: ['', nil], message: 'URL can\'t be blank' }
  validates :short, uniqueness: { case_sensitive: false,
				  message: 'URL has already been taken' }

  def check_link(user = nil)
    self.user = user
    self.original = 'http://' + original unless original =~ /^http/i
    self.short = id.to_s(36) if short.empty?
    self.save
  end
end
