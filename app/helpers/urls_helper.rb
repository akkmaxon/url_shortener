module UrlsHelper
  def show_full_address(short_url)
    'http://akkush.herokuapp.com/' + short_url
  end

  def urls_from_session
    session[:urls].map { |url_id| Url.find(url_id) }
  end
end
