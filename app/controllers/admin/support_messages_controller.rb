class Admin::SupportMessagesController < Admin::BaseController
  def index
    @messages = SupportMessage.order(created_at: :desc).page(params[:page])
  end

  def show
    @message = SupportMessage.find(params[:id])
    @message.update(read_at: Time.current, status: 1) if @message.read_at.nil?
  end

  def destroy
    @message = SupportMessage.find(params[:id])
    @message.destroy
    redirect_to admin_support_messages_path, notice: "Сообщение удалено"
  end
end