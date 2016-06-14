class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, exclusion: { in: ['', nil], message: 'URL can\'t be blank' }
  validates :short, uniqueness: { case_sensitive: false,
				  message: 'URL has already been taken' }

  def check_link(user = nil)
    self.user = user
    self.original = 'http://' + original unless original =~ /^http/i
    while short.empty?
      rand_num ||= 0
      new_short = (id + rand_num).to_s(36)
      self.short = new_short unless Url.find_by short: new_short
      rand_num = rand(1000000)
    end
    self.save
  end
end
