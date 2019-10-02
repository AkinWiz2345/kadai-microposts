class UsersController < ApplicationController
  before_action :require_user_logged_in, {only: [:index, :show, :profile, :followings, :followers, :likes]}
  before_action :privileged_user, {only: [:edit, :update, :destroy]}
  before_action :set_user, {only: [:show, :profile, :followings, :followers, :likes]}
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = 'Userは正常に更新されました'
      redirect_to @user
    else
      flash[:danger] = 'Userは更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = 'Userは正常に削除されました'
    redirect_to root_url
  end
  
  def profile
  end
  
  def followings
    @followings = @user.followings.page(params[:page])
  end
  
  def followers
    @followers = @user.followers.page(params[:page])
  end
  
  def likes
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end
  
  private
  
  def privileged_user
    @user = User.find_by(id: params[:id])
    unless current_user == @user
      flash[:danger] = '権限がありません'
      redirect_to @user
    end
  end
  
  def set_user
    @user = User.find(params[:id])
    counts(@user)
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :gender, :birthday, :hometown, :remarks)
  end
end
