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
def test
  subscription = current_user.push_subscriptions.last
  
  if subscription
    Webpush.payload_send(
      endpoint: subscription.endpoint,
      message: "🔔 Тестовое уведомление!",
      p256dh: subscription.p256dh,
      auth: subscription.auth,
      vapid: {
        subject: "mailto:larchenkovad@bk.ru",
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      }
    )
    render json: { success: true, message: "Уведомление отправлено" }
  else
    render json: { success: false, message: "Нет подписки" }, status: :not_found
  end
rescue => e
  render json: { success: false, error: e.message }, status: :internal_server_error
end
end
