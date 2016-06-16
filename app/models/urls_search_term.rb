class UrlsSearchTerm
  attr_reader :where_clause, :where_args, :order

  def initialize(keywords, commit)
    @keywords = keywords
    @where_clause = ''
    @where_args = {}
    @order = 'updated_at desc'
    case commit
    when 'Original URL' then search_original_url
    when 'Short URL' then search_short_url
    when 'Description' then search_description
    end
  end

  def search_original_url
    unique_keywords.each do |keyword|
      @where_clause << "#{@where_clause.empty? ? '' : ' OR '}original ilike :#{symbolize(keyword)}"
      @where_args[symbolize(keyword)] = "%#{keyword}%"
    end
  end

  def search_short_url
    unique_keywords.each do |keyword|
      @where_clause << "#{@where_clause.empty? ? '' : ' OR '}short ilike :#{symbolize(keyword)}"
      @where_args[symbolize(keyword)] = "%#{keyword}%"
    end
  end

  def search_description
    mix_keywords.each do |keyword|
      @where_clause << "#{@where_clause.empty? ? '' : ' OR '}description ilike :#{symbolize(keyword)}"
      @where_args[symbolize(keyword)] = "%#{keyword}%"
    end
  end

  private

  def unique_keywords
    k = @keywords.split(/\W/).uniq
    k.select {|keyword| keyword =~ /\w/ }
  end

  def mix_keywords
    k = unique_keywords << @keywords
    k.sort
  end

  def symbolize(keyword)
    keyword.gsub(/\W/, '').to_sym
  end
end
