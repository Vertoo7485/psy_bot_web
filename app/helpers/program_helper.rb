module ProgramHelper
  def day_has_timer?(day_number)
    ![3, 7, 8].include?(day_number)
  end

  def day_has_techniques?(day_number)
    [1, 4].include?(day_number)
  end

  def day_has_activity_selection?(day_number)
    day_number == 5
  end

  def day_has_rest_selection?(day_number)
    day_number == 6
  end

  def day_has_stop_signal?(day_number)
    day_number == 8
  end

  def day_is_gratitude?(day_number)
    day_number == 3
  end

  def day_is_reflection_week?(day_number)
    day_number == 7
  end

  def day_special_template?(day_number)
    [3, 7, 8].include?(day_number)
  end

  def technique_title(day_number)
    day_number == 4 ? "Выберите технику наблюдения" : "Выберите технику дыхания"
  end
end