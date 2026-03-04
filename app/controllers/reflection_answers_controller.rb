class ReflectionAnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer = current_user.reflection_answers.find_or_initialize_by(
      day_id: params[:reflection_answer][:day_id],
      question_key: params[:reflection_answer][:question_key]
    )
    
    answer.answer = params[:reflection_answer][:answer]
    
    if answer.save
      render json: { success: true }
    else
      render json: { success: false, errors: answer.errors.full_messages }, status: :unprocessable_entity
    end
  end
end