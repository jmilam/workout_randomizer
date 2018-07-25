module ProfileHelper
  def trending_img(weight)
    if weight.zero?
    elsif weight.positive?
      image_tag('trend_up', size: 100)
    else
      image_tag('trend_down', size: 100)
    end
  end

  def progress_percent(duration, progress)
    "#{((progress / duration.to_f) * 100)}%"
  end
end
