class EmotionDiaryEntriesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    entry_params = params[:entry]
    
    if entry_params.present?
      entry = EmotionDiaryEntry.create!(
        user: current_user,
        date: Date.current,
        situation: entry_params[:situation],
        thoughts: entry_params[:thoughts],
        emotions: entry_params[:emotions],
        behavior: entry_params[:behavior],
        evidence_against: entry_params[:evidence_against],
        new_thoughts: entry_params[:new_thoughts]
      )
      
      render json: { success: true, id: entry.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @entries = current_user.emotion_diary_entries.order(created_at: :desc)
  end
end