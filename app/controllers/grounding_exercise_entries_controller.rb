class GroundingExerciseEntriesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    entry_params = params[:entry]
    
    if entry_params.present?
      entry = GroundingExerciseEntry.create!(
        user: current_user,
        entry_date: Date.current,
        seen: entry_params[:seen],
        touched: entry_params[:touched],
        heard: entry_params[:heard],
        smelled: entry_params[:smelled],
        tasted: entry_params[:tasted]
      )
      
      render json: { success: true, id: entry.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @entries = current_user.grounding_exercise_entries.order(created_at: :desc)
  end
end