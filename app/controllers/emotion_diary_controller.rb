class EmotionDiaryController < ApplicationController
  before_action :authenticate_user!
  
  def new
    # Просто показываем страницу с формой
    @steps = [
      { 
        title: "Шаг 1: Ситуация", 
        question: "Опишите, что именно произошло?",
        example: "Например: Начальник сказал, что мой отчет нужно переделать",
        help: "Будьте конкретны: кто, что, где, когда. Это поможет позже найти закономерности."
      },
      { 
        title: "Шаг 2: Мысли", 
        question: "Какие мысли пришли вам в голову в тот момент?",
        example: "Например: Я всё делаю плохо, Меня скоро уволят",
        help: "Записывайте всё, даже если мысли кажутся глупыми или преувеличенными. Это важно."
      },
      { 
        title: "Шаг 3: Эмоции", 
        question: "Что вы почувствовали?",
        example: "Например: тревога, грусть, обида, раздражение",
        help: "Старайтесь называть эмоции точно. Не просто 'плохо', а 'разочарование' или 'беспокойство'."
      },
      { 
        title: "Шаг 4: Поведение", 
        question: "Как вы поступили в той ситуации?",
        example: "Например: промолчал, ушел, начал спорить, заплакал",
        help: "Что вы сделали сразу после того, как это произошло?"
      },
      { 
        title: "Шаг 5: Проверка мыслей", 
        question: "Что говорит против ваших мыслей?",
        example: "Например: Раньше мой отчет хвалили, Начальник всегда придирается",
        help: 'Спросите себя: "Что говорит против этой мысли? Какие есть альтернативные объяснения?"'
      },
      { 
        title: "Шаг 6: Новые мысли", 
        question: "Как можно подумать иначе, чтобы стало легче?",
        example: "Например: Это просто обратная связь, я могу доработать отчет",
        help: "Новая мысль должна быть более реалистичной и помогать, а не просто 'позитивной'."
      }
    ]
  end
  
  def create
    # Сохраняем запись
    entry = EmotionDiaryEntry.create!(
      user: current_user,
      date: Date.current,
      situation: params[:situation],
      thoughts: params[:thoughts],
      emotions: params[:emotions],
      behavior: params[:behavior],
      evidence_against: params[:evidence_against],
      new_thoughts: params[:new_thoughts]
    )
    
    render json: { success: true, id: entry.id }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  current_user.add_experience(5)   # +5 за запись в дневнике
  current_user.update_streak
end