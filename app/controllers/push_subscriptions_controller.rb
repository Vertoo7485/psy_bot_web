class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(
      endpoint: params[:push_subscription][:endpoint]
    )
    
    subscription.update(
      p256dh: params[:push_subscription][:p256dh],
      auth: params[:push_subscription][:auth]
    )

    render json: { success: true }
  end
end