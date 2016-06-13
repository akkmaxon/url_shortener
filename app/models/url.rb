class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, exclusion: { in: ['', nil], message: 'Original URL can\'t be blank' }

  def create_short_link(user = nil)
    self.user = user
    self.original = 'http://' + original unless original =~ /^http/i
    self.short = id.to_s(36) if short.empty?
    self.save
  end
end
