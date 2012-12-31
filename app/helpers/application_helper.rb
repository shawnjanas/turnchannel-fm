module ApplicationHelper
  def normalize_time(offset)
    time = Time.now.to_i

    from_time = time - (time % offset)
    to_time = time - (time % offset) - offset

    [from_time, to_time]
  end
end
