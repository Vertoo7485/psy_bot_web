class GratitudeEntriesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @entries = current_user.gratitude_entries.order(created_at: :desc)
  end
  
  def create
    entries = params[:entries]
    
    if entries.present?
      entries.each do |entry|
        GratitudeEntry.create!(
          user: current_user,
          entry_date: Date.current,
          entry_text: entry[:text]
        )
      end
      
      render json: { success: true }
    else
      render json: { success: false, error: "No entries provided" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  current_user.add_experience(5)   # +5 за благодарность
  current_user.update_streak
end