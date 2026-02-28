class CompassionLettersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    letter_params = params[:letter]
    
    if letter_params.present?
      # Собираем полный текст письма
      full_text = [
        "Ситуация: #{letter_params[:situation_text]}",
        "Понимание: #{letter_params[:understanding_text]}",
        "Поддержка: #{letter_params[:kindness_text]}",
        "Совет: #{letter_params[:advice_text]}",
        "Завершение: #{letter_params[:closure_text]}"
      ].compact.join("\n\n")
      
      letter = CompassionLetter.create!(
        user: current_user,
        entry_date: Date.current,
        situation_text: letter_params[:situation_text],
        understanding_text: letter_params[:understanding_text],
        kindness_text: letter_params[:kindness_text],
        advice_text: letter_params[:advice_text],
        closure_text: letter_params[:closure_text],
        full_text: full_text
      )
      
      render json: { success: true, id: letter.id }
    else
      render json: { success: false, error: "Нет данных" }, status: :unprocessable_entity
    end
    
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
  
  def index
    @letters = current_user.compassion_letters.order(created_at: :desc)
  end
end