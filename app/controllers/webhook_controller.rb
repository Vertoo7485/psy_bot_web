class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def yookassa
    # Логируем входящее уведомление
    Rails.logger.info "=== YOOKASSA WEBHOOK RECEIVED ==="
    Rails.logger.info "Event: #{params[:event]}"
    Rails.logger.info "Payment ID: #{params.dig(:object, :id)}"
    Rails.logger.info "Status: #{params.dig(:object, :status)}"
    Rails.logger.info "Paid: #{params.dig(:object, :paid)}"
    Rails.logger.info "=== END WEBHOOK ==="

    # Обрабатываем успешный платёж
    if params[:event] == 'payment.succeeded'
      payment_id = params.dig(:object, :metadata, :payment_id)
      
      if payment_id
        payment = Payment.find_by(id: payment_id)
        
        if payment && payment.update(status: 'succeeded')
          user = payment.user
          
          if user
            # Активируем премиум подписку на 30 дней
            user.activate_premium!(days: 30)
            Rails.logger.info "✅ Premium activated for user #{user.id}, payment #{payment.id}"
          end
        end
      end
    end

    head :ok
  end
end
