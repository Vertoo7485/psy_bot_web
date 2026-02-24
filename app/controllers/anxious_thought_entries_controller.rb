class AnxiousThoughtEntriesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    entry_params = params[:entry]
    
    if entry_params.present?
      entry = AnxiousThoughtEntry.create!(
        user: current_user,
        thought: entry_params[:thought],
        probability: entry_params[:probability],
        facts_pro: entry_params[:facts_pro],
        facts_con: entry_params[:facts_con],
        reframe: entry_params[:reframe],
        entry_date: Date.current
      )
      
      render json: { success: true, id: entry.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @entries = current_user.anxious_thought_entries.order(created_at: :desc)
  end
end