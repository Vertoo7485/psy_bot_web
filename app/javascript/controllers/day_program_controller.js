// app/javascript/controllers/day_program_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reflection", "timerButtons", "techniqueButtons", "activityButtons", "moodButtons", "gratitudeStep", "gratitudeInput"]
  
  connect() {
    this.selectedTechnique = null
    this.selectedMinutes = null
    this.practiceStarted = false
    this.selectedActivity = null
    this.selectedMood = null
    this.currentGratitudeStep = 0
    this.gratitudeEntries = []
    this.gratitudeSteps = []
  }
  
  selectTechnique(event) {
    const button = event.currentTarget
    this.selectedTechnique = button.dataset.technique
    
    // Визуальное выделение
    this.techniqueButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    
    console.log('Выбрана техника:', this.selectedTechnique)
  }
  
  selectTimer(event) {
    const button = event.currentTarget
    this.selectedMinutes = button.dataset.minutes
    
    // Визуальное выделение
    this.timerButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    
    if (this.selectedMinutes === 'custom') {
      const minutes = prompt('Введите количество минут (1-30):', '10')
      if (minutes && !isNaN(minutes) && minutes >= 1 && minutes <= 30) {
        this.selectedMinutes = minutes
        button.textContent = `${minutes} мин`
      } else {
        this.selectedMinutes = null
        button.classList.remove('btn-primary', 'text-white')
        button.classList.add('btn-outline-primary')
        alert('Пожалуйста, введите число от 1 до 30')
      }
    }
    
    console.log('Выбрано минут:', this.selectedMinutes)
  }
  
  selectActivity(event) {
    const button = event.currentTarget
    this.selectedActivity = button.dataset.activity

    // Визуальное выделение
    this.activityButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
      btn.closest('.activity-card')?.classList.remove('border-primary', 'border-2')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    button.closest('.activity-card')?.classList.add('border-primary', 'border-2')

    console.log('Выбрана активность:', this.selectedActivity)
  }
  
  selectMood(event) {
  const button = event.currentTarget
  this.selectedMood = button.dataset.mood
  
  // Находим родительскую карточку
  const card = button.closest('.card')
  
  // Визуальное выделение — убираем выделение со всех карточек
  document.querySelectorAll('#moodSelection .card').forEach(c => {
    c.classList.remove('border-success', 'border-2', 'bg-success', 'bg-opacity-10')
  })
  
  // Выделяем выбранную карточку
  if (card) {
    card.classList.add('border-success', 'border-2', 'bg-success', 'bg-opacity-10')
  }
  
  // Также выделяем саму кнопку (для совместимости со старым кодом)
  this.moodButtonsTargets.forEach(btn => {
    btn.classList.remove('btn-primary', 'text-white')
    btn.classList.add('btn-outline-primary')
  })
  button.classList.remove('btn-outline-primary')
  button.classList.add('btn-primary', 'text-white')
  
  // Сохраняем настроение
  this.saveMood(this.selectedMood)
  
  console.log('Выбрано настроение:', this.selectedMood)
}
  
  saveMood(moodIndex) {
    const moodOptions = [
      "Значительно лучше 😊",
      "Немного лучше 🙂", 
      "Без изменений 😐",
      "Хуже (усталость) 😔"
    ]
    
    this.selectedMoodText = moodOptions[moodIndex]
    
    // Отправляем на сервер или сохраняем локально
    console.log('Настроение сохранено:', this.selectedMoodText)
  }
  
  startPractice() {
    const dayNumber = this.data.get('dayNumber')
    const hasTechniques = this.techniqueButtonsTargets.length > 0
    const hasActivities = this.activityButtonsTargets.length > 0
    
    // Для дня 5 нужен выбор активности
    if (dayNumber == '5' && hasActivities && !this.selectedActivity) {
      alert('Сначала выберите тип активности')
      return
    }
    
    // Для дня 4 нужен выбор техники наблюдения
    if (dayNumber == '4' && hasTechniques && !this.selectedTechnique) {
      alert('Сначала выберите технику наблюдения')
      return
    }
    
    // Для дня 1 нужен выбор техники дыхания
    if (dayNumber == '1' && hasTechniques && !this.selectedTechnique) {
      alert('Сначала выберите технику дыхания')
      return
    }
    
    if (!this.selectedMinutes) {
      alert('Выберите время практики')
      return
    }
    
    this.practiceStarted = true
    
    // Скрываем кнопку старта, показываем таймер
    document.getElementById('startPractice').classList.add('d-none')
    
    // Создаем и показываем таймер
    this.showTimer()
  }
  
  showTimer() {
    const minutes = parseInt(this.selectedMinutes)
    let seconds = minutes * 60
    
    // Создаем элемент таймера
    const timerDiv = document.createElement('div')
    timerDiv.id = 'practiceTimer'
    timerDiv.className = 'text-center my-4 p-4 bg-light rounded'
    timerDiv.innerHTML = `
      <h3 class="display-1" id="timerDisplay">${minutes}:00</h3>
      <p class="text-secondary">Осталось времени</p>
      <button class="btn btn-danger" id="stopPractice">
        <i class="fas fa-stop me-2"></i>Завершить практику
      </button>
    `
    
    // Находим карточку упражнения
    const exerciseCard = document.querySelector('.card.border-primary .card-body')
    if (exerciseCard) {
      exerciseCard.appendChild(timerDiv)
    } else {
      console.error('Не найден блок для таймера')
      return
    }
    
    const timerDisplay = document.getElementById('timerDisplay')
    const stopButton = document.getElementById('stopPractice')
    
    const interval = setInterval(() => {
      seconds--
      const mins = Math.floor(seconds / 60)
      const secs = seconds % 60
      timerDisplay.textContent = `${mins}:${secs.toString().padStart(2, '0')}`
      
      if (seconds <= 0) {
        clearInterval(interval)
        this.completePractice()
      }
    }, 1000)
    
    stopButton.addEventListener('click', () => {
      clearInterval(interval)
      this.completePractice()
    })
  }
  
  completePractice() {
    // Убираем таймер
    document.getElementById('practiceTimer')?.remove()
    
    // Показываем рефлексию
    this.reflectionTarget.classList.remove('d-none')
    
    // Для дня 5 показываем выбор настроения
    const dayNumber = this.data.get('dayNumber')
    if (dayNumber == '5') {
      const moodSelection = document.getElementById('moodSelection')
if (moodSelection) {
  moodSelection.style.display = 'block'
}
    }
    
    // Показываем кнопку завершения дня
    document.getElementById('completeDay').classList.remove('d-none')
    
    // Прокручиваем к рефлексии
    this.reflectionTarget.scrollIntoView({ behavior: 'smooth' })
  }
  
  completeDay() {
    // Для дня 3 (благодарность) не проверяем практику
    const dayNumber = this.data.get('dayNumber')
    
    if (dayNumber != '3' && !this.practiceStarted) {
      alert('Сначала выполните практику')
      return
    }
    
    // Сохраняем прогресс через fetch
    fetch(`/programs/${this.data.get('programId')}/day/${this.data.get('dayNumber')}/complete`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        completed: true
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        window.location.href = `/programs?day_completed=${this.data.get('dayNumber')}`
      }
    })
  }

  // Методы для дня 3 (благодарность)
  startGratitudeExercise() {
    const exerciseData = JSON.parse(this.data.get('exerciseData') || '{}')
    this.gratitudeSteps = exerciseData.steps || []
    this.currentGratitudeStep = 0
    this.gratitudeEntries = []
    
    this.showGratitudeStep()
  }
  
  showGratitudeStep() {
    if (this.currentGratitudeStep >= this.gratitudeSteps.length) {
      this.completeGratitudeExercise()
      return
    }
    
    const step = this.gratitudeSteps[this.currentGratitudeStep]
    
    // Скрываем основное содержимое, показываем шаг
    document.querySelector('.card.border-primary').classList.add('d-none')
    
    let stepHtml = `
      <div class="card mb-4 border-success" id="gratitudeStep">
        <div class="card-header bg-success text-white">
          <h4 class="mb-0">Шаг ${this.currentGratitudeStep + 1} из ${this.gratitudeSteps.length}</h4>
        </div>
        <div class="card-body">
          <h5 class="mb-3">${step.prompt}</h5>
          <div class="alert alert-info">
            <ul class="mb-0">
              ${step.questions.map(q => `<li>${q}</li>`).join('')}
            </ul>
          </div>
          <div class="mb-3">
            <label class="form-label">Ваша благодарность:</label>
            <textarea class="form-control" 
                      id="gratitudeInput" 
                      rows="3" 
                      placeholder="${step.placeholder}"></textarea>
          </div>
          <div class="text-end">
            <button class="btn btn-success" onclick="this.dispatchEvent(new CustomEvent('save-gratitude'))">
              ${this.currentGratitudeStep < this.gratitudeSteps.length - 1 ? 'Далее' : 'Завершить'}
            </button>
          </div>
        </div>
      </div>
    `
    
    // Вставляем шаг после упражнения
    document.querySelector('.card.border-primary').insertAdjacentHTML('afterend', stepHtml)
    
    // Добавляем обработчик для кнопки
    document.querySelector('#gratitudeStep .btn-success').addEventListener('click', () => {
      const input = document.getElementById('gratitudeInput')
      if (!input.value.trim()) {
        alert('Пожалуйста, напишите вашу благодарность')
        return
      }
      
      this.gratitudeEntries.push({
        step: this.currentGratitudeStep,
        category: step.category,
        text: input.value.trim()
      })
      
      this.currentGratitudeStep++
      document.getElementById('gratitudeStep')?.remove()
      this.showGratitudeStep()
    })
  }
  
  completeGratitudeExercise() {
    document.getElementById('gratitudeStep')?.remove()
    document.querySelector('.card.border-primary').classList.remove('d-none')
    
    // Сохраняем в базу
    fetch('/gratitude_entries', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        entries: this.gratitudeEntries
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('✅ Благодарности сохранены!')
        // Показываем рефлексию
        this.reflectionTarget.classList.remove('d-none')
        document.getElementById('completeDay').classList.remove('d-none')
      }
    })
  }
}