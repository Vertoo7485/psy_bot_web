class MeditationSessionsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    session_params = params[:meditation_session]
    
    if session_params.present?
      meditation = MeditationSession.create!(
        user: current_user,
        duration_minutes: session_params[:duration_minutes],
        technique: session_params[:technique],
        rating: session_params[:rating],
        notes: session_params[:notes],
        completed_at: session_params[:completed_at] || Time.current
      )
      
      render json: { success: true, id: meditation.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @sessions = current_user.meditation_sessions.completed.order(completed_at: :desc)
  end
end