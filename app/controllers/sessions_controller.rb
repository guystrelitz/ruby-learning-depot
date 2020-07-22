class SessionsController < ApplicationController
  skip_before_action :authorise

  def new
  end

  def create
  	user = User.find_by name: params[:name]
  	if user.try :authenticate, params[:password]
  		session[:user_id] = user.id
  		redirect_to admin_url
  	else
      session[:user_id] = nil
  		redirect_to login_url, alert: 'Invalid user/password combination'
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to store_index_url, notice: 'Logged out'
  end
end
