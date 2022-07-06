class UsersController < ApplicationController

    before_action :require_logged_out, only: [:new, :create]
    before_action :require_logged_in, only: [:index, :show, :edit, :update]




    def create 
        @user = User.new(user_params) 

        if @user.save
        login(@user) 
        redirect_to cats_url
        else
        flash.now[:errors] = @user.errors.full_messages
        render :new
        end 
    end 

    def new 
        @user = User.new
        render :new
    end 


    private 
    def user_params
        params.require(:user).permit(:username, :password)
    end 

end