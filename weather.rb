require "http"
#WAVES#
def metric_to_feet(wave_height_metric)
  wave_height_feet=wave_height_metric * 3.28084
  wave_height_feet.round(1)
end

response = HTTP.get('https://marine-api.open-meteo.com/v1/marine?latitude=41.55&longitude=-71.29&hourly=wave_height&timezone=America%2FNew_York')
wave_height=response.parse(:json)
#this gets me the waveheights for next 5 days. I want to grab height for each day at 7 AM (13th index), Noon(18th index) and 5 PM(23rd index)
#The position in the returned data should be the same until the next day sa I still see the date from last midnight.
#The time is returned in UTC time so i'll need to figure that out
#Waves are in meters as well so ill need to times the returned value by 3.28084 to get accurate wave height in feet
#Right now if I use this past 6PM(the next day UTC, I will likely have a bug. I can refactor if I have time. But it is assumed I'll view this in the AM for that day or you get a idea of next 5 days.)
#Move code below into a has with K,V pairs for time of day and position in index
wave_seven_am=wave_height["hourly"]["wave_height"][13]
wave_twelve_pm=wave_height["hourly"]["wave_height"][18]
wave_five_pm=wave_height["hourly"]["wave_height"][23]    #this gets me the waveheights. 
feet= 3.28084

# puts "The wave height today at 7AM: #{metric_to_feet(wave_seven_am)} feet"
# puts "The wave height today at 12 PM: #{metric_to_feet(wave_twelve_pm)} feet"
# puts "The wave height today at 5 PM: #{metric_to_feet(wave_five_pm)} feet"

#-------------------------------------------------------------------------------------------------#
#WIND# Is represented in cardinal direction that needs to be broken down for simplicity
#Wind uses same indexes as waves.
#North is between 0-50 or 310-350
#South is between 140-230
#West sideshore is 231 - 309
#East sideshore is between 51-139
def convert_wind_from_cardinal_to_direction(cardinal_direction)
  if (cardinal_direction > 0  && cardinal_direction < 50) || (cardinal_direction > 309 && cardinal_direction<400)
    return "North"
  end
  if (cardinal_direction > 139  && cardinal_direction < 231)
    return "South"
  end
  if (cardinal_direction > 230  && cardinal_direction < 310)
    return "Sideshore West"
  end
  if (cardinal_direction > 50  && cardinal_direction < 140)
    return "Sideshore East"
  end

end
response = HTTP.get('https://api.open-meteo.com/v1/forecast?latitude=41.55&longitude=-71.29&hourly=temperature_2m,windspeed_10m,winddirection_10m&temperature_unit=fahrenheit&windspeed_unit=mph&precipitation_unit=inch')
wind_info=response.parse(:json)
wind_direction_seven_am=wind_info["hourly"]["winddirection_10m"][13]
wind_direction_twelve_pm=wind_info["hourly"]["winddirection_10m"][18]
wind_direction_five_pm=wind_info["hourly"]["winddirection_10m"][23]


puts wind_direction_seven_am
puts wind_direction_twelve_pm
puts wind_direction_five_pm
puts convert_wind_from_cardinal_to_direction(32)
puts convert_wind_from_cardinal_to_direction(140)
puts convert_wind_from_cardinal_to_direction(232)
puts convert_wind_from_cardinal_to_direction(60)

puts "7AM Forecast- Wave Height: #{metric_to_feet(wave_seven_am)} feet. Wind Direction: #{convert_wind_from_cardinal_to_direction(wind_direction_seven_am)}"
puts "The wave height today at 12 PM: #{metric_to_feet(wave_twelve_pm)} feet"
puts "The wave height today at 5 PM: #{metric_to_feet(wave_five_pm)} feet"
