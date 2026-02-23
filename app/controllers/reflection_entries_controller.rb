class ReflectionEntriesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    entries = params[:entries]
    
    if entries.present?
      entries.each do |entry|
        ReflectionEntry.create!(
          user: current_user,
          entry_date: Date.current,
          entry_text: entry[:text],
          category: entry[:category]
        )
      end
      
      render json: { success: true }
    else
      render json: { success: false, error: "Нет записей" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @entries = current_user.reflection_entries.order(created_at: :desc)
  end
end