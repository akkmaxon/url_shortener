class UrlsController < ApplicationController

  def index
  end

  def show
    @url = Url.find(params[:id])
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(create_short_url)
    if @url.save
      flash[:notice] = 'Short link has been created'
      redirect_to @url
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

  def create_short_url
    p = url_params
    return p if p[:original].empty?
    if p[:short].empty?
      #TODO make generating new short link
      p[:short] = 'i am not empty'
    end
    p
  end
end
