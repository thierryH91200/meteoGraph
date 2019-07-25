//
//  DailyForecast.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//


/**
 {"city":{"id":6440557,"name":"Pau","coord":{"lon":-0.3667,"lat":43.3}, "country":"FR", "population":0, "timezone":7200},
 "cod":"200",
 "message":2.1476547,
 "cnt":7,
 
 "list":[
 {"dt":1561377600,"temp":{"day":25.78,"min":16.64,"max":27.64,"night":16.93,"eve":26.75,"morn":25.78},"pressure":1013.07,"humidity":56,"weather":[{"id":804,"main":"Clouds","description":"couvert","icon":"04d"}],"speed":1.99,"deg":41,"clouds":94},
 {"dt":1561464000,"temp":{"day":26.85,"min":17.13,"max":28.95,"night":17.17,"eve":27.26,"morn":17.13},"pressure":1016.79,"humidity":59,"weather":[{"id":801,"main":"Clouds","description":"peu nuageux","icon":"02d"}],"speed":2.12,"deg":25,"clouds":17},
 {"dt":1561550400,"temp":{"day":30.82,"min":17.59,"max":34.7,"night":20.25,"eve":32.11,"morn":17.59},"pressure":1016.07,"humidity":50,"weather":[{"id":802,"main":"Clouds","description":"partiellement nuageux","icon":"03d"}],"speed":2.01,"deg":41,"clouds":26},
 {"dt":1561636800,"temp":{"day":33.67,"min":17.07,"max":35.75,"night":17.07,"eve":32.28,"morn":17.95},"pressure":1017.26,"humidity":45,"weather":[{"id":800,"main":"Clear","description":"ciel dégagé","icon":"01d"}],"speed":3.34,"deg":68,"clouds":0},
 {"dt":1561723200,"temp":{"day":25.85,"min":16.11,"max":29.45,"night":16.11,"eve":29.05,"morn":18.56},"pressure":1016.83,"humidity":63,"weather":[{"id":803,"main":"Clouds","description":"nuageux","icon":"04d"}],"speed":1.93,"deg":309,"clouds":60},
 {"dt":1561809600,"temp":{"day":22.56,"min":14.95,"max":25.56,"night":14.95,"eve":22.16,"morn":18.15},"pressure":1016.23,"humidity":71,"weather":[{"id":804,"main":"Clouds","description":"couvert","icon":"04d"}],"speed":3.66,"deg":284,"clouds":100},
 {"dt":1561896000,"temp":{"day":22.85,"min":15.57,"max":26.38,"night":15.57,"eve":25.98,"morn":17.6},"pressure":1017.9,"humidity":72,"weather":[{"id":803,"main":"Clouds","description":"nuageux","icon":"04d"}],"speed":2.4,"deg":293,"clouds":74}]}
 */

/*
 Parameters:
 
 city
     city.id             City ID
     city.name           City name
     city.coord
         city.coord.lat  City geo location, latitude
         city.coord.lon  City geo location, longitude
     city.country        Country code (GB, JP etc.)
     city.timezone       Shift in seconds from UTC
 cod Internal parameter
 message Internal parameter
 cnt Number of lines returned by this API call
 list
     list.dt Time of data forecasted
     list.temp
         list.temp.day Day temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
         list.temp.min Min daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
         list.temp.max Max daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
         list.temp.night Night temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
         list.temp.eve Evening temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
         list.temp.morn Morning temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     list.pressure Atmospheric pressure on the sea level, hPa
     list.humidity Humidity, %
     list.weather (more info Weather condition codes)
         list.weather.id Weather condition id
         list.weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
         list.weather.description Weather condition within the group
         list.weather.icon Weather icon id
     list.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
     list.deg Wind direction, degrees (meteorological)
     list.clouds Cloudiness, %
     list.rain Precipitation volume, mm
     list.snow Snow volume, mm
 */


import Foundation

/// Codable type that holds weather forecast information in a daily frequency
public struct DailyForecast: Codable {
    // Already has documentation
    public var city: City
    public var numberOfDataPoints: Int
    
    public var dataPoints: [DataPointDaily]
    
    enum CodingKeys: String, CodingKey {
        case city
        case numberOfDataPoints = "cnt"
        case dataPoints = "list"
    }
}

/// Helper struct that holds information on a daily basis
public struct DataPointDaily: Codable {
    /// The timestamp of the forecast measurement
    public var forecastTimeStamp: Double
    
    /// Holds information about the different temperatures troughtout the day
    public var temperature: Temperature
    
    /// Atmospheric pressure on the sea level measured in hPa
    var pressure: Double { return _pressure ?? 0 }
    /// Air humidity measured in percent
    var humidity: Int { return _humidity ?? 0 }
    
    /// Holds information about weather condition such description, group and id
    var condition: WeatherCondition { return _condition?.first ?? WeatherCondition.unknown }
    
    ///Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    var speed: Double { return _speed ?? 0 }
    /// Wind direction, degrees (meteorological)
    var deg: Int { return _deg ?? 0 }
    /// Cloudiness, %
    var clouds: Int { return _clouds ?? 0 }
    /// Precipitation volume, mm
    var rain: Double { return _rain ?? 0 }
    /// Snow volume, mm
    var snow: Int { return _snow ?? 0 }
    
    /// Atmospheric pressure on the sea level measured in hPa
    private var _pressure: Double?
    /// Air humidity measured in percent
    private var _humidity: Int?
    
    /// Internal property to handle array in JSON response that shouldn't be an array lol
    private var _condition: [WeatherCondition]?
    
    ///Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    private var _speed: Double?
    /// Wind direction, degrees (meteorological)
    private var _deg: Int?
    /// Internal property to handle missing "clouds" key in JSON reponse
    private var _clouds: Int?
    /// Internal property to handle missing "rain" key in JSON reponse
    private var _rain: Double?
    /// Internal property to handle missing "snow" key in JSON reponse
    private var _snow: Int?
    
    enum CodingKeys: String, CodingKey {
        case forecastTimeStamp = "dt"
        case temperature = "temp"
        
        case _pressure = "pressure"
        case _humidity = "humidity"
        
        case _condition = "weather"
        
        case _speed = "speed"
        case _deg = "deg"
        case _clouds = "clouds"
        case _rain = "rain"
        case _snow = "snow"
    }
}

public struct Temperature: Codable {
    /// Avery day temperature on that day
    var day: Double
    /// Avery night temperature on that day
    var night: Double
    /// Avery evening temperature on that day
    var evening: Double
    /// Avery morning temperature on that day
    var morning: Double
    /// Minimum temperature on that day
    var minimum: Double
    /// Maximum temperature on that day
    var maximum: Double
    
    enum CodingKeys: String, CodingKey {
        case day = "day"
        case night = "night"
        case minimum = "min"
        case maximum = "max"
        case morning = "morn"
        case evening = "eve"
    }
}


public class CntRequest: WeatherRequest {
    
    public var cnt: String
    
    public func queryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "cnt", value: self.cnt)]
    }
    
    public init(_ cnt: String) {
        self.cnt = cnt
    }
}

