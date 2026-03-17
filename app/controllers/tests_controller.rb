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
      
      # Сохраняем ответ для ТЕКУЩЕГО вопроса
      answered_question = current_question - 1
      
      session[:test_answers] ||= {}
      session[:test_answers][answered_question.to_s] = params[:answer]
      
      # Переходим к следующему вопросу
      next_question = current_question
      
      # Проверяем, не закончился ли тест
      total_questions = if @test.category == 'anxiety'
                          40
                        elsif @test.category == 'depression'
                          21
                        elsif @test.category == 'eq'
                          30
                        elsif @test.category == 'stress'
                          10
                        else
                          0
                        end
      
      if next_question >= total_questions
        redirect_to submit_test_path(@test)
      else
        redirect_to question_test_path(@test, question: next_question)
      end
      return
    end
    
    # Если это GET - просто показываем вопрос
    @question_index = params[:question].to_i
    
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
    elsif @test.category == 'depression'
      @questions = @test.questions
      @current_question = @questions[@question_index]
      @type = "depression"
      @total_questions = 21
    elsif @test.category == 'eq'
      @questions = @test.questions
      @current_question = @questions[@question_index]
      @type = "eq"
      @total_questions = 30
    elsif @test.category == 'stress'
      @questions = @test.questions
      @current_question = @questions[@question_index]
      @type = "stress"
      @total_questions = 10
    end
  end
  
  def submit
    @test = Test.find(params[:id])
    answers = session[:test_answers] || {}
    
    if @test.category == 'anxiety'
      # Подсчет для тревожности
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
      total_score = 0
      (0..20).each do |i|
        total_score += answers[i.to_s].to_i
      end
      
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
      }
      
    elsif @test.category == 'stress'
      total_score = 0
      (0..9).each do |i|
        score = answers[i.to_s].to_i
        # Обратные вопросы: 4,5,7,8 (индексы 3,4,6,7)
        if [3,4,6,7].include?(i)
          score = 4 - score
        end
        total_score += score
      end
      
      interpretation_text = @test.config["interpretation"].find do |i|
        range = i["range"].split("-").map(&:to_i)
        total_score >= range[0] && total_score <= range[1]
      end["text"]
      
      interpretation = {
        stress: interpretation_text
      }
      
      score_data = {
        total: total_score
      }
    end
    
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
    
    # Добавляем опыт
    current_user.add_experience(20)
    current_user.update_streak
    
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