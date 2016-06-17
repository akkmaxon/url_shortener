class Url < ActiveRecord::Base
  belongs_to :user
  validates :original, exclusion: { in: ['http://', '', nil], message: 'URL can\'t be blank' }
  validates :short, uniqueness: { case_sensitive: false,
				  message: 'URL has already been taken' }

  def generate_short_and_save
    time_of_creating = Time.now.to_i
    self.original = 'http://' + self.original unless self.original =~ /^http/i
    self.short = clear_forbidden(self.short)
    while self.short.empty?
      rand_num ||= 0
      new_short = (time_of_creating + rand_num).to_s(36)
      self.short = new_short unless Url.find_by short: new_short
      rand_num = rand(1000000)
    end
    save
  end

  def clear_forbidden(link)
    %w[ urls stats].each do |f|
      return '' if link == f
    end
    link
  end
end
