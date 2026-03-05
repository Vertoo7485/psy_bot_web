module AdminConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :require_admin
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "У вас нет доступа к этой странице"
    end
  end
end