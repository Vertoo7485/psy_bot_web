class KindnessEntriesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    entry_params = params[:entry]
    
    if entry_params.present?
      entry = KindnessEntry.create!(
        user: current_user,
        entry_date: Date.current,
        act: entry_params[:act],
        reaction: entry_params[:reaction],
        feelings: entry_params[:feelings]
      )
      
      render json: { success: true, id: entry.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @entries = current_user.kindness_entries.order(created_at: :desc)
  end
end