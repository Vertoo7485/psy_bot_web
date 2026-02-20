// app/javascript/controllers/day_program_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reflection", "timerButtons", "techniqueButtons"]
  
  connect() {
    this.selectedTechnique = null
    this.selectedMinutes = null
    this.practiceStarted = false
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
  
  startPractice() {
    if (!this.selectedTechnique) {
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
    
    // Звуковой сигнал (работает только после взаимодействия с страницей)
    const audio = new Audio('data:audio/wav;base64,UklGRlwAAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YVAAAAA8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PDw8PA==')
    audio.play().catch(e => console.log('Аудио не поддерживается'))
    // Показываем рефлексию
    this.reflectionTarget.classList.remove('d-none')
    
    // Показываем кнопку завершения дня
    document.getElementById('completeDay').classList.remove('d-none')
    
    // Прокручиваем к рефлексии
    this.reflectionTarget.scrollIntoView({ behavior: 'smooth' })
  }
  
  completeDay() {
    if (!this.practiceStarted) {
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
        technique: this.selectedTechnique,
        minutes: this.selectedMinutes
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        window.location.href = `/programs?day_completed=${this.data.get('dayNumber')}`
      }
    })
  }
}