class Admin::DashboardController < Admin::BaseController
  def index
    @users_count = User.count
    @premium_users = User.premium_users.count
    @free_users = User.free_users.count
    @program_completions = UserDayProgress.where(completed: true).count
    @recent_users = User.order(created_at: :desc).limit(10)
  end
end
