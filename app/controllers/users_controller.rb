class UsersController < ApplicationController
  def index
    @users = UserDecorator.decorate_collection(User.all.order(:username))
  end

  def show
    @user = User.find_by(username: params[:username])
    @repositories = @user.repositories.order(:creation_date)
  end

  def create
    @user = GithubRetrieveService.new(params[:username]).retrieve_user
    @repositories = @user.repositories
    render 'users/show'
  rescue Octokit::NotFound
    flash[:error] = "GitHub user not found"
    redirect_to root_path
  end
end
