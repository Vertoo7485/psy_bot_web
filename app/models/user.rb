class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :test_results, dependent: :destroy
  has_many :user_programs, dependent: :destroy
  has_many :user_day_progresses, dependent: :destroy
  has_many :programs, through: :user_programs
  has_many :gratitude_entries, dependent: :destroy
  has_many :reflection_entries, dependent: :destroy
  has_many :anxious_thought_entries, dependent: :destroy
  has_many :emotion_diary_entries, dependent: :destroy
  has_many :grounding_exercise_entries, dependent: :destroy
  has_many :self_compassion_practices, dependent: :destroy
  has_many :procrastination_tasks, dependent: :destroy
  has_many :kindness_entries, dependent: :destroy
  has_many :reconnection_practices, dependent: :destroy
  has_many :compassion_letters, dependent: :destroy
  has_many :pleasure_activities, dependent: :destroy
  has_many :meditation_sessions, dependent: :destroy
  has_many :fear_conquests, dependent: :destroy
  has_many :reflection_answers, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :push_subscriptions, dependent: :destroy
  has_one :experience, dependent: :destroy
  has_one :streak, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements
  has_many :garden_elements, dependent: :destroy

  include GardenProgress

  # Поля для подписки (из бота)
  attribute :access_level, :string, default: 'free'
  attribute :is_active, :boolean, default: true
  attribute :subscription_ends_at, :datetime
  attribute :trial_ends_at, :datetime
  attribute :premium_activated_at, :datetime

  # Валидации
  validates :access_level, inclusion: { in: %w[free premium admin] }

  # Callback для новых пользователей
  after_create :set_initial_trial, if: :new_user?

  # Scopes (из бота)
  scope :free_users, -> { where(access_level: 'free') }
  scope :premium_users, -> { where(access_level: 'premium') }
  scope :admin_users, -> { where(access_level: 'admin') }
  scope :active_users, -> { where(is_active: true) }
  
  scope :with_active_subscription, -> {
    premium_users
      .active_users
      .where('subscription_ends_at > ?', Time.current)
  }

  # Методы для подписки (из бота)
  def free?
    access_level == 'free'
  end

  def premium?
    access_level == 'premium'
  end

  def admin?
    access_level == 'admin'
  end

  def has_active_premium?
    premium? && is_active && (trial_active? || subscription_active?)
  end

  def subscription_active?
    return false unless premium?
    subscription_ends_at.present? && subscription_ends_at > Time.current
  end

  def trial_active?
    return false unless premium?
    trial_ends_at.present? && trial_ends_at > Time.current
  end

  def activate_premium!(days: 30)
    new_ends_at = if subscription_ends_at && subscription_ends_at > Time.current
      subscription_ends_at + days.days
    else
      Time.current + days.days
    end

    update!(
      access_level: 'premium',
      subscription_ends_at: new_ends_at,
      premium_activated_at: Time.current,
      is_active: true,
      trial_ends_at: nil
    )
  end

  def days_until_subscription_ends
    return 0 unless subscription_ends_at && subscription_ends_at > Time.current
    (subscription_ends_at.to_date - Date.current).to_i
  end

  def can_start_day?(day_number, program_id)
    return true if day_number == 1
    
    previous_day = Day.find_by(program_id: program_id, day_number: day_number - 1)
    previous_progress = user_day_progresses.find_by(day: previous_day, completed: true)
    
    return false unless previous_progress
    
    # Считаем от начала предыдущего дня, а не от завершения
    Time.current - previous_progress.started_at >= 12.hours
  end

  def time_until_next_day(day_number, program_id)
    return 0 if day_number == 1
    
    previous_day = Day.find_by(program_id: program_id, day_number: day_number - 1)
    previous_progress = user_day_progresses.find_by(day: previous_day, completed: true)
    
    return 0 unless previous_progress
    
    time_passed = Time.current - previous_progress.started_at
    if time_passed < 12.hours
      (12.hours - time_passed).ceil
    else
      0
    end
  end

  private

  def set_initial_trial
    update(
      access_level: 'premium',
      trial_ends_at: 3.days.from_now,
      is_active: true
    )
    Rails.logger.info "User #{id} activated 3-day trial"
  end

  def new_user?
    true # Все новые пользователи получают триал
  end

  # Проверка статуса подписки (вызывается перед сохранением)
  before_save :check_subscription_status

  def check_subscription_status
    # Если триал истек и нет активной подписки
    if premium? && trial_ends_at && trial_ends_at <= Time.current && !subscription_active?
      self.access_level = 'free'
      self.trial_ends_at = nil
      Rails.logger.info "User #{id} auto-downgraded from premium to free (trial expired)"
    end
    
    # Если подписка истекла
    if premium? && subscription_ends_at && subscription_ends_at <= Time.current
      self.access_level = 'free'
      self.subscription_ends_at = nil
      Rails.logger.info "User #{id} auto-downgraded from premium to free (subscription expired)"
    end
  end
end
