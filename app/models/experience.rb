class Experience < ApplicationRecord
  belongs_to :user
  
  after_initialize :set_defaults, if: :new_record?
  
  def add_points(points)
    self.total_points += points
    self.level = (total_points / 100).floor + 1
    self.next_level_at = (level * 100) - total_points
    save
  end
  
  private
  
  def set_defaults
    self.total_points ||= 0
    self.level ||= 1
    self.next_level_at ||= 100
  end
end