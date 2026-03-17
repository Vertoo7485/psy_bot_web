class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  @user = User.find(params[:id])
end

def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    redirect_to admin_user_path(@user), notice: 'Статус пользователя обновлён'
  else
    render :edit
  end
end

def edit_password
  @user = User.find(params[:id])
end

def update_password
  @user = User.find(params[:id])
  
  if @user.update(user_password_params)
    redirect_to admin_user_path(@user), notice: "Пароль пользователя успешно изменён"
  else
    render :edit_password
  end
end

private

def user_params
  params.require(:user).permit(:access_level, :subscription_ends_at, :trial_ends_at)
end

def user_password_params
  params.require(:user).permit(:password, :password_confirmation)
end
end
