class PleasureActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:update]
  
  def create
    activity_params = params[:activity]
    
    if activity_params.present?
      activity = PleasureActivity.create!(
        user: current_user,
        title: activity_params[:title],
        activity_type: activity_params[:activity_type],
        feelings_before: activity_params[:feelings_before],
        planned_time: activity_params[:planned_time],
        completed: activity_params[:completed] || false
      )
      
      render json: { success: true, id: activity.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def update
    if @activity.update(activity_update_params)
      render json: { success: true }
    else
      render json: { success: false, error: @activity.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @activities = current_user.pleasure_activities.completed.order(completed_at: :desc)
  end
  
  private
  
  def set_activity
    @activity = current_user.pleasure_activities.find(params[:id])
  end
  
  def activity_update_params
    params.require(:activity).permit(
      :feelings_after, 
      :reflection, 
      :completed, 
      :completed_at
    )
  end
end