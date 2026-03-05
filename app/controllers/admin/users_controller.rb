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

private

def user_params
  params.require(:user).permit(:access_level, :subscription_ends_at, :trial_ends_at)
end
end
