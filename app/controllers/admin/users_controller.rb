class Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @grid = UsersGrid.new(params[:users_grid])
    @assets = @grid.assets.page(params[:page])
  end
  
  def edit
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(users_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def update
    notice = 'User was successfully updated.'
    
    if params[:lock]
      @user.lock
      notice = 'User was successfully locked.'
    elsif params[:unlock]
      @user.unlock
      notice = 'User was successfully unlocked.'
    end
    
    respond_to do |format|
      if @user.update(users_params)
        format.html { redirect_to [:edit, :admin, @user], notice: notice }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  protected 
  
  def users_params
    params.require(:user).permit(:email, :password, :password_confirmation, :representative_id)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
