class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_experation, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "cant be empty")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      # clear out digest after successful update
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
  # Before filters
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  #confirms a valid user
  def valid_user
    unless(@user && @user.activated? &&
          @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
  
  #Checks experation of reset token.
  def check_experation
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end
  
end
