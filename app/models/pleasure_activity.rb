class PleasureActivity < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :activity_type, presence: true
  
  scope :completed, -> { where(completed: true) }
  scope :recent, -> { order(created_at: :desc) }
  
  def mood_improvement
    return 0 unless feelings_before && feelings_after
    feelings_after - feelings_before
  end
  
  def type_emoji
    {
      'reading' => '📚',
      'music' => '🎵',
      'art' => '🎨',
      'sports' => '🏃',
      'nature' => '🌳',
      'cooking' => '🍳',
      'games' => '🎮',
      'learning' => '🧠',
      'social' => '👥',
      'relaxation' => '🧘',
      'other' => '✨'
    }[activity_type] || '🌟'
  end
end