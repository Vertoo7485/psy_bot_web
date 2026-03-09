class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    amount = params[:amount].to_i * 100  # переводим рубли в копейки
    
    payment_record = current_user.payments.create!(
      amount: amount,
      currency: 'RUB',
      status: 'pending',
      payment_type: 'subscription'
    )

    service = YookassaService.new
    result = service.create_payment(
      amount: amount,
      description: "Премиум подписка на 30 дней",
      metadata: {
        user_id: current_user.id,
        payment_id: payment_record.id,
        payment_type: 'subscription'
      }
    )

    if result[:success]
      payment_record.update!(
        yookassa_id: result[:payment_id],
        confirmation_url: result[:confirmation_url]
      )
      
      redirect_to result[:confirmation_url], allow_other_host: true
    else
      flash[:alert] = "Ошибка при создании платежа: #{result[:error]}"
      redirect_to premium_path
    end
  end

  def success
    flash[:notice] = "Платёж обрабатывается. Статус обновится в течение нескольких минут."
    redirect_to profile_path
  end
end