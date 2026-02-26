class ProcrastinationTasksController < ApplicationController
  before_action :authenticate_user!
  
  def create
    task_params = params[:task]
    
    if task_params.present?
      task = ProcrastinationTask.create!(
        user: current_user,
        entry_date: Date.current,
        task: task_params[:task],
        reason: task_params[:reason],
        steps: task_params[:steps],
        first_step: task_params[:first_step],
        feelings_after: task_params[:feelings_after],
        completed: task_params[:completed] || false
      )
      
      render json: { success: true, id: task.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @tasks = current_user.procrastination_tasks.order(created_at: :desc)
  end
end