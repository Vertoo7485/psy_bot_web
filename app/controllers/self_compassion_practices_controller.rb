class SelfCompassionPracticesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    practice_params = params[:practice]
    
    if practice_params.present?
      practice = SelfCompassionPractice.create!(
        user: current_user,
        entry_date: Date.current,
        current_difficulty: practice_params[:current_difficulty],
        common_humanity: practice_params[:common_humanity],
        kind_words: practice_params[:kind_words],
        mantra: practice_params[:mantra]
      )
      
      render json: { success: true, id: practice.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @practices = current_user.self_compassion_practices.order(created_at: :desc)
  end
end