class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user_path(user.id), success: 'You are now logged as #{@user.name}'
    else
      flash[:alert] =  'Sorry log in failed!'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'You are logged out'
  end
end
