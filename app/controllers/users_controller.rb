class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_param)
    if @user.save
      log_in @user
      flash[:success] = 'New user is successfully created and logged'
      redirect_to user_path(@user.id)
    else
      flash[:alert] = "Something went wrong: #{@user.errors.full_messages}"
      render :new
    end
  end

  def show
    current_user
    if logged_in?
      @user = User.find(params[:id])
    else
      redirect_to login_path, alert: "Sorry, you must login to access to this page"
    end
  end

  def edit
    current_user
    if logged_in? && current_user.id == params[:id].to_i
      @user = User.find(params[:id])
    elsif logged_in?
      redirect_to root_path, alert: "Sorry, you don't have access rights to this page"
    else
      redirect_to login_path, alert: "Sorry, you must login to access to this page"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_param)
      flash[:success] = 'User information successfully updated'
      redirect_to user_path(params[:id])
    else
      redirect_to edit_user_path(params[:id]), alert: "Something went wrong, information couldn't be updated: #{@user.errors.full_messages}"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      log_out
      flash[:success] = 'User has been successfuly deleted'
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong: #{@user.errors.full_messages}"
      render :show
    end
  end

  private

  def user_param
    params.require(:user).permit(:last_name, :first_name, :email, :password)
  end
end
