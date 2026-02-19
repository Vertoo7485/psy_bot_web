class TestsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  
  def index
    @tests = Test.all
  end
  
  def show
    @test = Test.find(params[:id])
  end
  
  def start
    @test = Test.find(params[:id])
    session[:test_answers] = {}
    session[:test_started_at] = Time.current
    redirect_to question_test_path(@test, question: 0)
  end

  def question
    @test = Test.find(params[:id])
    
    # Если это POST (пришел ответ)
    if request.post? && params[:answer].present?
    current_question = params[:question].to_i
    
    # Важно! Сохраняем ответ для ТЕКУЩЕГО вопроса (который только что видел пользователь)
    # current_question - 1, потому что в URL приходит следующий номер
    answered_question = current_question - 1
    
    session[:test_answers] ||= {}
    session[:test_answers][answered_question.to_s] = params[:answer]
    puts "Сохранен ответ на вопрос #{answered_question}: #{params[:answer]}"
    
    # Переходим к следующему вопросу
    next_question = current_question
    
    if next_question >= 40
      redirect_to submit_test_path(@test)
    else
      redirect_to question_test_path(@test, question: next_question)
    end
    return
  end
  
  # Если это GET - просто показываем вопрос
  @question_index = params[:question].to_i
  puts "========== ВОПРОС #{@question_index} =========="
  puts "Всего сохранено ответов: #{session[:test_answers]&.size}"
  
  # Определяем тип вопросов
  if @question_index < 20
    @type = "situational"
    @questions = @test.questions["situational"]
  else
    @type = "personal"
    @questions = @test.questions["personal"]
  end
  
  @current_question = @questions[@question_index % 20]
end

  def submit
  @test = Test.find(params[:id])
  answers = session[:test_answers] || {}
  
  puts "Все ответы: #{answers.inspect}"
  
  # Подсчет баллов для ситуативной тревожности (вопросы 0-19)
  situational_score = 0
    (0..19).each do |i|
      score = answers[i.to_s].to_i
      # Проверяем, есть ли этот вопрос в обратных
      if @test.config["scoring"]["situational"]["reverse"].include?(i + 1)
        score = 5 - score
      end
      situational_score += score
    end

    # Подсчет баллов для личностной тревожности (вопросы 20-39)
    personal_score = 0
    (20..39).each do |i|
      score = answers[i.to_s].to_i
      if @test.config["scoring"]["personal"]["reverse"].include?(i - 19)
        score = 5 - score
      end
      personal_score += score
    end
  
  puts "Итоговые баллы: situational=#{situational_score}, personal=#{personal_score}"
  
  # Сохраняем результат
  result = TestResult.create!(
    user: current_user,
    test: @test,
    answers: answers,
    score: {
    situational: situational_score,
    personal: personal_score,
    total: situational_score + personal_score
    }.to_json,
    interpretation: {
      situational: interpret_score(situational_score, @test.config["interpretation"]["situational"]),
      personal: interpret_score(personal_score, @test.config["interpretation"]["personal"])
    }.to_json,
    started_at: session[:test_started_at],
    completed_at: Time.current
  )
  
  # Очищаем сессию
  session.delete(:test_answers)
  session.delete(:test_started_at)
  
  redirect_to test_result_path(result)
end

  private

  def interpret_score(score, interpretations)
    interpretations.each do |int|
      range = int["range"].split("-").map(&:to_i)
      if score >= range[0] && score <= range[1]
        return int["text"]
      end
    end
    "Не удалось интерпретировать"
  end
end