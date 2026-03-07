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
    
    answered_question = current_question - 1
    
    session[:test_answers] ||= {}
    session[:test_answers][answered_question.to_s] = params[:answer]
    puts "Сохранен ответ на вопрос #{answered_question}: #{params[:answer]}"
    
    next_question = current_question
    
    if (@test.category == 'anxiety' && next_question >= 40) || 
       (@test.category == 'depression' && next_question >= 21) ||
       (@test.category == 'eq' && next_question >= 30)
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
  
  # Проверяем, не закончился ли тест
  if (@test.category == 'anxiety' && @question_index >= 40) || 
     (@test.category == 'depression' && @question_index >= 21) ||
     (@test.category == 'eq' && @question_index >= 30)
    redirect_to submit_test_path(@test)
    return
  end
  
  # Определяем тип вопросов в зависимости от категории теста
  if @test.category == 'anxiety'
    if @question_index < 20
      @type = "situational"
      @questions = @test.questions["situational"]
      @current_question = @questions[@question_index]
    else
      @type = "personal"
      @questions = @test.questions["personal"]
      @current_question = @questions[@question_index - 20]
    end
    @total_questions = 40
  else
    # Для депрессии и EQ
    @questions = @test.questions
    @current_question = @questions[@question_index]
    
    if @test.category == 'depression'
      @type = "depression"
      @total_questions = 21
    else  # eq
      @type = "eq"
      @total_questions = 30
    end
  end
end

def submit
  @test = Test.find(params[:id])
  answers = session[:test_answers] || {}
  
  puts "Все ответы: #{answers.inspect}"
  
  if @test.category == 'anxiety'
    # Подсчет для теста тревожности Спилбергера-Ханина
    situational_score = 0
    (0..19).each do |i|
      score = answers[i.to_s].to_i
      if @test.config["scoring"]["situational"]["reverse"].include?(i + 1)
        score = 5 - score
      end
      situational_score += score
    end

    personal_score = 0
    (20..39).each do |i|
      score = answers[i.to_s].to_i
      if @test.config["scoring"]["personal"]["reverse"].include?(i - 19)
        score = 5 - score
      end
      personal_score += score
    end
    
    total_score = situational_score + personal_score
    
    interpretation = {
      situational: interpret_score(situational_score, @test.config["interpretation"]["situational"]),
      personal: interpret_score(personal_score, @test.config["interpretation"]["personal"])
    }
    
    score_data = {
      situational: situational_score,
      personal: personal_score,
      total: total_score
    }
    
  elsif @test.category == 'depression'
    # Для BDI-II все вопросы суммируются (0-3)
    total_score = 0
    (0..20).each do |i|  # 21 вопрос (0-20)
      total_score += answers[i.to_s].to_i
    end
    
    # Находим интерпретацию по общей сумме
    interpretation_text = @test.config["interpretation"].find do |i|
      range = i["range"].split("-").map(&:to_i)
      total_score >= range[0] && total_score <= range[1]
    end["text"]
    
    interpretation = {
      depression: interpretation_text
    }
    
    score_data = {
      total: total_score
    }

  elsif @test.category == 'eq'
  total_score = 0
  subscales = {
    well_being: 0,
    self_control: 0,
    emotionality: 0,
    sociability: 0
  }
  
  (0..29).each do |i|
    score = answers[i.to_s].to_i
    if @test.questions[i]["reverse"]
      score = 8 - score
    end
    total_score += score
    
    # Распределяем по субшкалам
    question_number = i + 1
    if [3, 9, 13, 20, 30].include?(question_number)
      subscales[:well_being] += score
    elsif [7, 12, 14, 16, 18, 22, 25].include?(question_number)
      subscales[:self_control] += score
    elsif [1, 2, 4, 10, 15, 17, 21, 26, 27].include?(question_number)
      subscales[:emotionality] += score
    elsif [5, 11, 19, 23, 28].include?(question_number)
      subscales[:sociability] += score
    end
  end
  
  interpretation_text = @test.config["interpretation"].find do |i|
    range = i["range"].split("-").map(&:to_i)
    total_score >= range[0] && total_score <= range[1]
  end["text"]
  
  interpretation = {
    eq: interpretation_text
  }
  
  score_data = {
    total: total_score,
    subscales: subscales
}.to_json
  current_user.add_experience(20)  # +20 опыта за тест
  current_user.update_streak
  end

  
  
  puts "Итоговые баллы: #{score_data}"
  
  # Сохраняем результат
  result = TestResult.create!(
    user: current_user,
    test: @test,
    answers: answers,
    score: score_data.to_json,
    interpretation: interpretation.to_json,
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