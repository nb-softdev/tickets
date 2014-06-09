Time::DATE_FORMATS[:month_and_year] = "%B %Y"
Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%d/%m/%Y %H:%M") }
Time::DATE_FORMATS[:pretty_time] = lambda { |time| time.strftime("%H:%M:%S") }
Time::DATE_FORMATS[:pretty_view] = lambda { |time| time.strftime("%a, %b %e %Y") }
Time::DATE_FORMATS[:month_day_and_year] = "%a, %b %e %Y"
Time::DATE_FORMATS[:year_month_day] = "%B %d %Y" 
Time::DATE_FORMATS[:default_date_time] = lambda { |time| time.strftime("%d/%m/%Y %H:%M") }
Time::DATE_FORMATS[:default_date] = lambda { |time| time.strftime("%d/%m/%Y") }
Time::DATE_FORMATS[:default_time] = lambda { |time| time.strftime("%H:%M") }

Time::DATE_FORMATS[:system_date] = lambda { |time| time.strftime("%Y-%m-%d") }
