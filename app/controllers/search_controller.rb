class SearchController < ApplicationController
  def search_results
    unless params[:search_keywords].empty?
      keywords = params[:search_keywords]
      search_direction = params[:commit]
      urls_search_term = UrlsSearchTerm.new(keywords, search_direction)
      @result = Url.where(
	urls_search_term.where_clause,
	urls_search_term.where_args).
	order(urls_search_term.order)
    else
      flash[:alert] = 'Your search request is empty'
      @result = nil
    end
  end
end
