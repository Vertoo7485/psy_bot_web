class TestResultsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @result = TestResult.find(params[:id])
    
    # Проверяем, что результат принадлежит текущему пользователю
    if @result.user != current_user
      redirect_to root_path, alert: "У вас нет доступа к этому результату"
      return
    end
    
    @test = @result.test
  end
end