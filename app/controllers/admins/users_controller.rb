class Admins::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @search = @users.all.ransack params[:q]
    if params[:q].nil?
      @users = @users.page(params[:page]).per Settings.admin.user.per_page
    else
      @users = @search.result.page(params[:page]).
        per Settings.admin.user.per_page
    end
  end

  def create
    if @user.save
      flash[:success] = t "user.add_success"
      redirect_to admins_users_path
    else
      flash[:danger] = t "user.add_fail"
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "user.edit_success"
      redirect_to admins_users_path
    else
      flash[:danger] = t "user.edit_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.delete_success"
    else
      flash[:danger] = t "user.delete_fail"
    end
    redirect_to admins_users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :chatwork_name, :password,
      :password_confirmation
  end
end
