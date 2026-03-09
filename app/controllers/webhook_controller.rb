class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def yookassa
    # Здесь будет обработка уведомлений от ЮKassa
    # Пока просто логируем
    Rails.logger.info "Webhook received: #{params.to_json}"
    
    head :ok
  end
end