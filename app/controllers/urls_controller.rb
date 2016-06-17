class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]
  before_action :set_url, only: [:edit, :update, :destroy]
  before_action :find_blank_short_urls, only: :create
  after_action :remove_absent_link_from_session, only: :create

  def index
    @urls = current_user.urls
  end

  def show
    @url = Url.find_by(short: params[:short])
    if @url
      redirect_to @url.original
    else
      add_absent_link_to_session(params[:short])
      flash[:alert] = 'This link is absent but you can create it'
      redirect_to new_url_path
    end
  end

  def new
    @url = Url.new
  end

  def create
    @url = if user_signed_in? then current_user.urls.build(url_params)
	   else Url.new(url_params)
	   end
    if @url.generate_short_and_save
      add_short_url_to_session(@url)
      flash[:notice] = 'Short link has been created'
      redirect_to user_signed_in? ? urls_path : root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @url.update(url_params)
      flash[:notice] = 'Short link has been updated'
      redirect_to urls_path
    else
      render :edit
    end
  end

  def destroy
    @url.destroy
    flash[:notice] = 'Url has been deleted'
    redirect_to urls_path
  end

  private

  def url_params
    params.require(:url).permit(:original, :short, :description)
  end

  def set_url
    @url = Url.find(params[:id])
  end

  def add_short_url_to_session(url)
    session[:urls] ||= []
    session[:urls] << url.id
  end

  def add_absent_link_to_session(link)
    session[:absent_link] ||= ''
    session[:absent_link] = link
  end

  def remove_absent_link_from_session
    session.delete(:absent_link) if session.key? :absent_link
  end

  def find_blank_short_urls
    url = Url.find_by(short: '')
    url.generate_short_and_save unless url.nil?
  end
end
