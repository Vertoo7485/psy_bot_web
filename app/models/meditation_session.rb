class MeditationSession < ApplicationRecord
  belongs_to :user
  
  scope :completed, -> { where.not(completed_at: nil) }
  scope :recent, -> { order(completed_at: :desc) }
  
  def formatted_date
    completed_at.strftime('%d.%m.%Y')
  end
  
  def technique_name
    {
      'breathing_anchor' => 'Дыхание-якорь',
      'body_scan' => 'Сканирование тела',
      'loving_kindness' => 'Любящая доброта',
      'mindfulness' => 'Осознанность'
    }[technique] || 'Базовая медитация'
  end
  
  def self.average_rating
    where.not(rating: nil).average(:rating).to_f.round(1)
  end
  
  def self.total_minutes
    sum(:duration_minutes)
  end
end