class ClubController < ApplicationController
    def home
      current_user
    end

    def private
      current_user
      redirect_to root_path, alert: 'Nice try! Please log in to enter the club' unless logged_in?
      @users = User.all
    end
end
