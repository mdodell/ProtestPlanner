module DatesHelper
  def get_date_month_long date, capitalized
    capitalized ? date.strftime("%^B") : date.strftime("%B")
  end

  def get_date_month_short date, capitalized
    capitalized ? date.strftime("%^b") : date.strftime("%b")
  end

  def get_date_day_number date
    date.strftime("%d")
  end

  def get_date_day_short date, capitalized
    capitalized ? date.strftime("%^a") : date.strftime("%a")
  end

  def get_date_day_long date, capitalized
    capitalized ? date.strftime("%^A") : date.strftime("%A")
  end

  def get_full_date_and_time date
    "#{get_full_date(date)} #{get_full_time(date)}"
  end

  def get_full_date date
    date.strftime("%A, %b %d %Y")
  end

  def get_full_time date
    date.strftime("%k:%M %p")
  end
end