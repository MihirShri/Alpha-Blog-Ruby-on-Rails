class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user_edit, only: [:edit, :update]
  before_action :require_same_user_delete, only: [:destroy]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5).custom_display
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5).custom_display
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to Alpha Blog #{ @user.username }, you have successfully signed up!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile has been updated successfully!"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:notice] = "Account and all associated articles successfully deleted!"
    redirect_to articles_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user_edit
    if current_user != @user
      flash[:alert] = "You can only edit your own profile!"
      redirect_to @user
    end
  end

  def require_same_user_delete
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only delete your own profile!"
      redirect_to @user
    end
  end

end