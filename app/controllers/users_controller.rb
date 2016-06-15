class UsersController < ApplicationController
  def index
    @users = UserDecorator.decorate_collection(User.all)
  end

  def show
    @user = User.find_by(username: params[:username])
    @repositories = @user.repositories
  end
end
