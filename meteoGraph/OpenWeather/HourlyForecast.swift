//
//  Forecast.swift
//  OpenWeatherSwift
//
//  Created by Henrik Panhans on 12.02.17.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

/**
 # code Internal parameter
 # message Internal parameter
 
 # city
    city.id City ID
    city.name City name
    city.coord
    city.coord.lat City geo location, latitude
    city.coord.lon City geo location, longitude
    city.country Country code (GB, JP etc.)
    cnt Number of lines returned by this API call
 
 # list
    list.dt Time of data forecasted, unix, UTC
 
    #list.main
        list.main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        list.main.temp_min Minimum temperature at the moment of calculation. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        list.main.temp_max Maximum temperature at the moment of calculation. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        list.main.pressure Atmospheric pressure on the sea level by default, hPa
        list.main.sea_level Atmospheric pressure on the sea level, hPa
        list.main.grnd_level Atmospheric pressure on the ground level, hPa
        list.main.humidity Humidity, %
        list.main.temp_kf Internal parameter
 
    # list.weather (more info Weather condition codes)
        list.weather.id Weather condition id
        list.weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
        list.weather.description Weather condition within the group
        list.weather.icon Weather icon id
 
    # list.clouds
        list.clouds.all Cloudiness, %
 
    # list.wind
        list.wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
        list.wind.deg Wind direction, degrees (meteorological)
 
    # list.rain
        list.rain.1h Rain volume for last hour, mm
 
    # list.snow
        list.snow.1h Snow volume for last hour
 
    #list.dt_txt Data/time of calculation, UTC

 */

import Foundation

/// Codable type that holds weather forecast information in an hourly frequency
public struct HourlyForecast: Codable {
    
    public var city: City
    public var numberOfDataPoints: Int
    
    /// The datapoints returned by the API
    public var dataPoints: [ListHourly]
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case numberOfDataPoints = "cnt"
        case dataPoints = "list"
    }
}

/// Codable type that represents a data points based on an hourly frequency
public struct ListHourly: WeatherSnapshot {
    
    /// The timestamp of the forecast measurement
    public var forecastTimeStamp: Double
    
    public var main: Main
    
    public var condition: WeatherCondition { return self._condition?.first ?? WeatherCondition.unknown }
    
    public var wind: Wind
    public var snow: Precipitation { return _snow ?? Precipitation.none }
    public var rain: Precipitation { return _rain ?? Precipitation.none }
    public var cloudCoverage: Int { return self._clouds?.all ?? 0 }
    
    /// The time of data calculation on the server. Data is refreshed every 10 minutes
    public var dt: Date {
        return ListHourly.dateFormatter.date(from: _timeOfCalculation ?? "1970-01-01 00:00:00") ?? Date.distantPast
    }
    
    /// Internal date formatter to convert date string returned by API into usable Date object
    static private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    internal var _snow: Precipitation?
    internal var _rain: Precipitation?
    /// Internal property to handle optional key "clouds" in JSON response
    internal var _clouds: Clouds?
    /// Internal property to handle string returned by API instead of seconds since epoch
    internal var _timeOfCalculation: String?
    /// Handles array in JSON response that should not be an array
    internal var _condition: [WeatherCondition]?
}

extension ListHourly {
    enum CodingKeys: String, CodingKey {
        case forecastTimeStamp = "dt"
        case _timeOfCalculation = "dt_txt"
        case _snow = "snow"
        case _rain = "rain"
        case main
        case _condition = "weather"
        case wind
        case _clouds = "clouds"
    }

}
