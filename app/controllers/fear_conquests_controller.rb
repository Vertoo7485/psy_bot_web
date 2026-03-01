class FearConquestsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    conquest_params = params[:fear_conquest]
    
    if conquest_params.present?
      conquest = FearConquest.create!(
        user: current_user,
        conquered_at: conquest_params[:conquered_at] || Time.current,
        category: conquest_params[:category],
        action: conquest_params[:action],
        micro_steps: conquest_params[:micro_steps],
        reflection: conquest_params[:reflection]
      )
      
      render json: { success: true, id: conquest.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @conquests = current_user.fear_conquests.order(conquered_at: :desc)
  end
end