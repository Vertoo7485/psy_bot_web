import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reflection", "timerButtons", "techniqueButtons", "activityButtons", "moodButtons", "restButtons", "stateButtons", "signalButtons", "strategyButtons", "gratitudeStep", "gratitudeInput"]
  
  connect() {
    this.selectedTechnique = null
    this.selectedMinutes = null
    this.practiceStarted = false
    this.selectedActivity = null
    this.selectedMood = null
    this.selectedRest = null
    this.selectedState = null
    this.selectedSignal = null
    this.selectedStrategy = null
    this.currentGratitudeStep = 0
    this.gratitudeEntries = []
    this.gratitudeSteps = []
  }

  selectRest(event) {
    const button = event.currentTarget
    this.selectedRest = button.dataset.rest

    this.restButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
      btn.closest('.rest-card')?.classList.remove('border-primary', 'border-2')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    button.closest('.rest-card')?.classList.add('border-primary', 'border-2')

    console.log('Выбран отдых:', this.selectedRest)
  }

  selectState(event) {
    const button = event.currentTarget
    this.selectedState = button.dataset.state
    
    const card = button.closest('.card')
    
    document.querySelectorAll('#stateSelection .card').forEach(c => {
      c.classList.remove('border-success', 'border-2', 'bg-success', 'bg-opacity-10')
    })
    
    if (card) {
      card.classList.add('border-success', 'border-2', 'bg-success', 'bg-opacity-10')
    }
    
    this.stateButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    
    console.log('Выбрано состояние:', this.selectedState)
  }
  
  selectTechnique(event) {
    const button = event.currentTarget
    this.selectedTechnique = button.dataset.technique
    
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
    
    const card = button.closest('.card')
    
    document.querySelectorAll('#moodSelection .card').forEach(c => {
      c.classList.remove('border-success', 'border-2', 'bg-success', 'bg-opacity-10')
    })
    
    if (card) {
      card.classList.add('border-success', 'border-2', 'bg-success', 'bg-opacity-10')
    }
    
    this.moodButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    
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
    console.log('Настроение сохранено:', this.selectedMoodText)
  }

  selectSignal(event) {
    const button = event.currentTarget
    this.selectedSignal = button.dataset.signal

    this.signalButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
      btn.closest('.signal-card')?.classList.remove('border-primary', 'border-2', 'bg-light')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    button.closest('.signal-card')?.classList.add('border-primary', 'border-2', 'bg-light')

    console.log('Выбран сигнал:', this.selectedSignal)
  }

  selectStrategy(event) {
    const button = event.currentTarget
    this.selectedStrategy = button.dataset.strategy

    this.strategyButtonsTargets.forEach(btn => {
      btn.classList.remove('btn-primary', 'text-white')
      btn.classList.add('btn-outline-primary')
      btn.closest('.strategy-card')?.classList.remove('border-primary', 'border-2', 'bg-light')
    })
    button.classList.remove('btn-outline-primary')
    button.classList.add('btn-primary', 'text-white')
    button.closest('.strategy-card')?.classList.add('border-primary', 'border-2', 'bg-light')

    console.log('Выбрана стратегия:', this.selectedStrategy)
  }
  
  startPractice() {
    const dayNumber = this.data.get('dayNumber')
    const hasTechniques = this.techniqueButtonsTargets.length > 0
    const hasActivities = this.activityButtonsTargets.length > 0
    const hasRest = this.restButtonsTargets.length > 0
    const hasSignals = this.signalButtonsTargets?.length > 0

    if (dayNumber == '8') {
      return
    }
    
    if (dayNumber == '6' && hasRest && !this.selectedRest) {
      alert('Сначала выберите тип отдыха')
      return
    }
    
    if (dayNumber == '5' && hasActivities && !this.selectedActivity) {
      alert('Сначала выберите тип активности')
      return
    }
    
    if (dayNumber == '4' && hasTechniques && !this.selectedTechnique) {
      alert('Сначала выберите технику наблюдения')
      return
    }
    
    if (dayNumber == '1' && hasTechniques && !this.selectedTechnique) {
      alert('Сначала выберите технику дыхания')
      return
    }
    
    if (!this.selectedMinutes) {
      alert('Выберите время практики')
      return
    }
    
    this.practiceStarted = true
    
    document.getElementById('startPractice').classList.add('d-none')
    
    this.showTimer()
  }
  
  showTimer() {
    const minutes = parseInt(this.selectedMinutes)
    let seconds = minutes * 60
    
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
      alert('Метод completePractice вызван!')  // ← добавить эту строку

    // Визуальное оповещение
    const notification = document.createElement('div')
    notification.className = 'alert alert-success alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3'
    notification.style.zIndex = '9999'
    notification.innerHTML = `
      <i class="fas fa-check-circle me-2"></i>
      Время практики закончилось!
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `
    document.body.appendChild(notification)
    
    // Звук через Web Audio
    try {
      const AudioContext = window.AudioContext || window.webkitAudioContext
      const ctx = new AudioContext()
      const now = ctx.currentTime
      
      if (ctx.state === 'suspended') {
        ctx.resume()
      }
      
      const osc = ctx.createOscillator()
      const gain = ctx.createGain()
      osc.connect(gain)
      gain.connect(ctx.destination)
      osc.type = 'sine'
      osc.frequency.value = 880
      gain.gain.value = 0.3
      osc.start()
      gain.gain.exponentialRampToValueAtTime(0.00001, now + 0.5)
      osc.stop(now + 0.5)
      
      setTimeout(() => {
        if (ctx.state === 'closed') return
        const osc2 = ctx.createOscillator()
        const gain2 = ctx.createGain()
        osc2.connect(gain2)
        gain2.connect(ctx.destination)
        osc2.type = 'sine'
        osc2.frequency.value = 660
        gain2.gain.value = 0.3
        osc2.start()
        gain2.gain.exponentialRampToValueAtTime(0.00001, ctx.currentTime + 0.5)
        osc2.stop(ctx.currentTime + 0.5)
      }, 300)
      
      setTimeout(() => {
        notification.remove()
      }, 3000)
      
    } catch (e) {
      console.log('Audio error:', e)
      setTimeout(() => {
        notification.remove()
      }, 3000)
    }
    
    // Вибрация
    if (navigator.vibrate) {
      navigator.vibrate([200, 100, 200])
    }
    
    document.getElementById('practiceTimer')?.remove()
    
    this.reflectionTarget.classList.remove('d-none')
    
    const dayNumber = this.data.get('dayNumber')
    
    if (dayNumber == '5') {
      const moodSelection = document.getElementById('moodSelection')
      if (moodSelection) {
        moodSelection.style.display = 'block'
      }
    }

    if (dayNumber == '6') {
      const stateSelection = document.getElementById('stateSelection')
      if (stateSelection) {
        stateSelection.style.display = 'block'
      }
    }
    
    document.getElementById('completeDay').classList.remove('d-none')
    
    this.reflectionTarget.scrollIntoView({ behavior: 'smooth' })
  }
  
  completeDay() {
    const dayNumber = this.data.get('dayNumber')
    
    if (dayNumber != '3' && dayNumber != '7' && dayNumber != '8' && dayNumber != '9' && dayNumber != '10' && dayNumber != '11' && dayNumber != '12' && dayNumber != '13' && dayNumber != '14' && dayNumber != '15' && dayNumber != '16' && dayNumber != '17' && dayNumber != '18' && dayNumber != '19' && dayNumber != '20' && dayNumber != '21' && dayNumber != '22' && dayNumber != '23' && dayNumber != '24' && dayNumber != '25' && dayNumber != '26' && dayNumber != '27' && !this.practiceStarted) {
      alert('Сначала выполните практику')
      return
    }
    
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
    
    document.querySelector('.card.border-primary').insertAdjacentHTML('afterend', stepHtml)
    
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
        this.reflectionTarget.classList.remove('d-none')
        document.getElementById('completeDay').classList.remove('d-none')
      }
    })
  }
}