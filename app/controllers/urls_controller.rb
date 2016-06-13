class UrlsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]

  def index
    @urls = current_user.urls
  end

  def show
    @url = Url.find(params[:id])
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      @url.create_short_link(current_user)
      add_short_url_to_session(@url) unless user_signed_in?
      flash[:notice] = 'Short link has been created'
      redirect_to user_signed_in? ? urls_path : root_path
    else
      flash.now[:alert] = 'Original URL can\'t be blank' if @url.original.empty?
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def url_params
    params.require(:url).permit(:original, :short, :description)
  end

  def add_short_url_to_session(url)
    session[:urls] ||= {}
    session[:urls][url.original] = url.short
  end
end
