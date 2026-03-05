class ProgramsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_premium, except: [:index]
  before_action :set_program, only: [:show, :day, :complete_day]
  
  def show
    @program = Program.find(params[:id])
    @user_program = current_user.user_programs.find_or_create_by(program: @program)
  end

  def index
    @programs = Program.all
  end
  
  def day
  @day = @program.days.find_by(day_number: params[:day_number])
  
  # Проверяем, можно ли начать этот день
  unless current_user.can_start_day?(@day.day_number, @program.id)
    time_left = current_user.time_until_next_day(@day.day_number, @program.id)
    hours = time_left / 3600
    minutes = (time_left % 3600) / 60
    
    flash[:alert] = "Следующий день будет доступен через #{hours} ч #{minutes} мин"
    redirect_to program_path(@program)
    return
  end
  
  @progress = current_user.user_day_progresses.find_or_create_by(day: @day) do |p|
    p.started_at = Time.current
  end
  
  @reflection_answers = current_user.reflection_answers
                                    .where(day: @day)
                                    .pluck(:question_key, :answer)
                                    .to_h
end
  
  def complete_day
    @day = @program.days.find_by(day_number: params[:day_number])
    @progress = current_user.user_day_progresses.find_by(day: @day)
    
    if @progress.update(
      completed: true,
      completed_at: Time.current,
      answers: params[:answers]  # техника и время из JS
    )
      
      # Обновляем текущий день в программе пользователя
      user_program = current_user.user_programs.find_by(program: @program)
      user_program.update(current_day: @day.day_number + 1) if @day.day_number < 28
      
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  def reset
    @program = Program.find(params[:id])
    current_user.user_day_progresses.where(day: @program.days).destroy_all
    redirect_to program_path(@program), notice: "Программа сброшена. Можно начать заново!"
  end
  
  private
  
  def set_program
    @program = Program.find(params[:id])
  end

  def require_premium
  unless current_user.has_active_premium?
    redirect_to premium_path, alert: "Программа самопомощи доступна только с премиум-подпиской"
  end
end
end