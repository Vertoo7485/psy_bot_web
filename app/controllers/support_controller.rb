class SupportController < ApplicationController
  def new
    @name = current_user&.email || ''
  end

  def create
    message = SupportMessage.new(
      name: params[:name],
      message: params[:message],
      status: 0
    )

    if message.save
      redirect_to root_path, notice: "Сообщение отправлено!"
    else
      flash.now[:alert] = "Пожалуйста, заполните все поля"
      render :new
    end
  end
end