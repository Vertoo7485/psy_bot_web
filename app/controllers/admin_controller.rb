class AdminController < ApplicationController
  include AdminConcern

  def dashboard
    @users_count = User.count
    @premium_users = User.premium_users.count
    @free_users = User.free_users.count
    @program_completions = UserDayProgress.where(completed: true).count
    @recent_users = User.order(created_at: :desc).limit(10)
  end

  def users
    @users = User.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def user
    @user = User.find(params[:id])
  end
end