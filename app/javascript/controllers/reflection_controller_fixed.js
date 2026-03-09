export default class extends window.Controller {
  static targets = ["question", "input", "saveButton"]
  static values = { 
    dayId: Number,
    answers: Object 
  }

  connect() {
    console.log("Reflection controller connected")
    this.currentQuestion = null
    this.loadSavedAnswers()
  }

  loadSavedAnswers() {
    Object.keys(this.answersValue || {}).forEach(key => {
      const questionEl = this.element.querySelector(`[data-question-key="${key}"]`)
      if (questionEl) {
        const icon = questionEl.querySelector('.answer-icon')
        if (icon) {
          icon.innerHTML = '✅'
          icon.classList.add('text-success')
        }
      }
    })
  }

  askQuestion(event) {
    const button = event.currentTarget
    this.currentQuestion = button.dataset.questionKey
    
    this.inputTargets.forEach(input => input.classList.add('d-none'))
    
    const inputDiv = this.element.querySelector(`#input-${this.currentQuestion}`)
    if (inputDiv) {
      inputDiv.classList.remove('d-none')
      
      const savedAnswer = this.answersValue?.[this.currentQuestion]
      if (savedAnswer) {
        const textarea = inputDiv.querySelector('textarea')
        if (textarea) {
          textarea.value = savedAnswer
        }
      }
      
      inputDiv.scrollIntoView({ behavior: 'smooth', block: 'center' })
    }
  }

  saveAnswer(event) {
    event.preventDefault()
    const form = event.currentTarget
    const questionKey = form.dataset.questionKey
    const textarea = form.querySelector('textarea')
    const answer = textarea.value.trim()
    
    if (!answer) {
      alert('Пожалуйста, напишите ответ')
      return
    }

    const saveBtn = form.querySelector('button[type="submit"]')
    const originalText = saveBtn.innerHTML
    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Сохранение...'
    saveBtn.disabled = true

    fetch('/reflection_answers', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        reflection_answer: {
          day_id: this.dayIdValue,
          question_key: questionKey,
          answer: answer
        }
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        const questionEl = this.element.querySelector(`[data-question-key="${questionKey}"]`)
        if (questionEl) {
          const icon = questionEl.querySelector('.answer-icon')
          if (icon) {
            icon.innerHTML = '✅'
            icon.classList.add('text-success')
          }
        }
        
        const inputDiv = this.element.querySelector(`#input-${questionKey}`)
        if (inputDiv) {
          inputDiv.classList.add('d-none')
        }
        
        this.answersValue = { ...(this.answersValue || {}), [questionKey]: answer }
        this.showNotification('Ответ сохранен!', 'success')
      } else {
        this.showNotification('Ошибка при сохранении', 'error')
      }
    })
    .catch(error => {
      console.error('Error:', error)
      this.showNotification('Ошибка соединения', 'error')
    })
    .finally(() => {
      saveBtn.innerHTML = originalText
      saveBtn.disabled = false
    })
  }

  showNotification(message, type) {
    const notification = document.createElement('div')
    notification.className = `alert alert-${type === 'success' ? 'success' : 'danger'} alert-dismissible fade show position-fixed top-0 end-0 m-3`
    notification.style.zIndex = '9999'
    notification.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `
    document.body.appendChild(notification)
    setTimeout(() => notification.remove(), 3000)
  }
}
