module GardenProgress
  extend ActiveSupport::Concern

  included do
    has_many :garden_elements, dependent: :destroy
    after_create :initialize_garden
  end

  def initialize_garden
    # Создаем запись опыта, если нет
    create_experience unless experience
    create_streak unless streak
    
    # Добавляем первый элемент (росток) за регистрацию
    add_garden_element('sprout')
  end

  def add_garden_element(element_type)
    template = GardenElementTemplate.find_by(element_type: element_type)
    return unless template

    garden_elements.find_or_create_by!(
      element_type: element_type,
      name: template.name,
      icon: template.icon,
      color: template.color,
      position_x: template.default_position['x'],
      position_y: template.default_position['y'],
      unlocked_at: Time.current
    )
  end

  def check_achievements
    Achievement.all.each do |achievement|
      next if user_achievements.exists?(achievement: achievement)

      if achievement_conditions_met?(achievement)
        user_achievements.create!(achievement: achievement, earned_at: Time.current)
        
        # Добавляем элемент в сад, если есть связанный шаблон
        template = GardenElementTemplate.find_by(achievement: achievement.title)
        add_garden_element(template.element_type) if template
      end
    end
  end

  def add_experience(points)
    experience.add_points(points)
    check_achievements
  end

  def update_streak
    streak.update_streak
    check_achievements
  end

  private

  def achievement_conditions_met?(achievement)
    condition = achievement.condition

    case condition['type']
    when 'test_count'
      test_results.count >= condition['value']
    when 'streak'
      streak&.current_streak.to_i >= condition['value']
    when 'diary_entries'
      emotion_diary_entries.count >= condition['value']
    when 'gratitude_entries'
      gratitude_entries.count >= condition['value']
    when 'day_completed'
      user_day_progresses.where(completed: true, day_id: condition['value']).exists?
    when 'days_completed'
      user_day_progresses.where(completed: true).count >= condition['value']
    else
      false
    end
  end
end