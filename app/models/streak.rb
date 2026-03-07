class Streak < ApplicationRecord
  belongs_to :user
  
  def update_streak
    if last_activity_at && last_activity_at > 1.day.ago
      self.current_streak += 1
      self.longest_streak = [longest_streak, current_streak].max
    else
      self.current_streak = 1
    end
    self.last_activity_at = Time.current
    save
  end
end