module UrlsHelper
  def show_full_address(short_url)
    HOSTNAME + short_url
  end

  def urls_from_session
    session[:urls].map { |url_id| Url.find(url_id) }
  end
end
