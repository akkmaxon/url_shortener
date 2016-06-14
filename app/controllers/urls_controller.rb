class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]
  before_action :set_url, only: [:edit, :update, :destroy]
  before_action :find_blank_short_urls, only: :create

  def index
    @urls = current_user.urls
  end

  def show
    @url = Url.find_by(short: params[:short])
    if @url
      redirect_to @url.original
    else
      flash[:alert] = 'This link is absent but you can create it'
      redirect_to new_url_path
    end
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      @url.check_link(current_user)
      add_short_url_to_session(@url) unless user_signed_in?
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
      @url.check_link(current_user)
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
    session[:urls] ||= {}
    session[:urls][url.original] = url.short
  end

  def find_blank_short_urls
    url = Url.find_by(short: '')
    url.check_link(current_user) unless url.nil?
  end
end
