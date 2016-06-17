class OmniauthCallbacksController < ApplicationController
  def all
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: @user.provider
      sign_in @user
      redirect_to root_path
    else
      failure
    end
  end

  def failure
    flash[:alert] = 'Oops, this application is not very good. Sign up manually, please'
    redirect_to new_user_registration_path
  end

  alias_method :vk, :all
  alias_method :twitter, :all
end
