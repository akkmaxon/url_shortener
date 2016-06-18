module SearchHelper
  def what_we_looking_for(params)
   "@result.count %> '<%= params[:search_keywords] %>' in '<%= params[:commit] %>':</h1>"
   unique_words = UrlsSearchTerm.new(params[:search_keywords], 
				     params[:commit]).unique_keywords
   "'#{unique_words.join("' or '")}' in '#{params[:commit]}'"
  end
end
