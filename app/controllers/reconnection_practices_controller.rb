class ReconnectionPracticesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    practice_params = params[:practice]
    
    if practice_params.present?
      practice = ReconnectionPractice.create!(
        user: current_user,
        entry_date: Date.current,
        reconnected_person: practice_params[:reconnected_person],
        communication_format: practice_params[:communication_format],
        conversation_start: practice_params[:conversation_start],
        reflection_text: practice_params[:reflection_text],
        integration_plan: practice_params[:integration_plan]
      )
      
      render json: { success: true, id: practice.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @practices = current_user.reconnection_practices.order(created_at: :desc)
  end
end