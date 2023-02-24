require "http"
city= ""
#while city != "Q"
puts "Pleae enter a city to see the current weather!...or enter 'Q' to quit"
city=gets.chomp

puts "Please enter Celsius or Farenheit" #Metric: Celsius, Imperial: Fahrenheit.
units=gets.chomp
unit = " "

if units == "Celsius"
  unit = "metric"
else
  unit ="imperial"
end


response = HTTP.get("http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{ENV["OPEN_WEATHER_API_KEY"]}&units=#{unit}")

weather=response.parse(:json)
 puts "The current temp in #{city.capitalize()} is #{weather["main"]["temp"]}"#need to remove 2 decimals



