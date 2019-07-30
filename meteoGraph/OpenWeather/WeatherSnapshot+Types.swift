//
//  SnapshotSubtypes.swift
//  HPOpenWeather
//
//  Created by Henrik Panhans on 28.04.19.
//  Copyright © 2019 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation

/// Type that holds information about the reqeuest's nearest city
public struct City: Codable {
    /// The ID assigned to the city
    public var id : Int
    /// The name of the city
    public var name: String
    /// The location of the city
    public var location: Coordinates
    /// The country code of the city
    public var countryCode: String
    /// Shift in seconds from UTC
    public var timezone: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case location = "coord"
        case countryCode = "country"
        case timezone = "timezone"
    }
}

/// Custom Location type which holds latitude and longitude, similar to CLLocationCoordinate2D
public struct Coordinates: Codable {
    /// Longitude of the object
    public var longitude: Double
    /// Latitude of the object
    public var latitude: Double
    
    func _2d() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

/// Type that holds system information such as country code, sunrise and sunset times
public struct System: Codable {
    /**
     [Wikipedia]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes "See full list"
     
     An ISO 3166 country code specifying the country of the request's location. For a full list of codes see [Wikipedia]
     */
    var countryCode: String
    /// The sunrise time of the request's location in UTC time
    var sunrise: Date
    /// The sunset time of the request's location in UTC time
    var sunset: Date
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunrise
        case sunset
    }
}

/// Type that holds information about sunrise and sunset times in UTC time
public struct Sun: Codable {
    /// Sunset time in UTC time
    public var set: Date
    /// Sunrise time in UTC time
    public var rise: Date
    
    enum CodingKeys: String, CodingKey {
        case set = "sunset"
        case rise = "sunrise"
    }
}

/// Type that holds the main information of the request, such as temperature, humidity, etc.
public struct Main: Codable {
    /// The current temperature in the format specified in the request
    public var temperature: Double?
    /// The current humidity measured in percent
    public var humidity: Int
    /// The current air pressure measured in hPa
    public var pressure: Double
    /// The minimum temperature reached on the day of the request
    public var temperatureMin: Double
    /// The maximum temperature reached on the day of the request
    public var temperatureMax: Double
    /// The current sea level pressure measured in hPa (Note: Is zero when data is unavailable)
    public var seaLevelPressure: Double { return _seaLvl ?? 0.00 }
    /// The current ground level pressure measured in hPa (Note: Is zero when data is unavailable)
    public var groundLevelPressure: Double { return _groundLvl ?? 0.00 }
    
    /// Internal type to handle missing sea level pressure data
    private var _seaLvl: Double?
    /// Internal type to handle missing ground level pressure data
    private var _groundLvl: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case pressure
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case _seaLvl = "sea_level"
        case _groundLvl = "grnd_level"
    }
}

/// Type that holds information about wind speed and direction measured in degrees
public struct Wind: Codable {
    /// The current wind speed depending on the request's unit (metric: meter/second, imperial: miles/hour)
    public var speed: Double
    /// The wind direction measured in degrees from North
    public var degrees: Double { return _degrees ?? 0.00 }
    
    private var _degrees: Double?

    enum CodingKeys: String, CodingKey {
        case speed
        case _degrees = "deg"
    }
}

/// Type that holds information about weather conditions
public struct WeatherCondition: Codable {
    /// The weather condition ID
    public var id: Int
    /// Group of weather parameters
    public var main: String
    /// The weather condition within the group
    public var description: String
    /// The ID of the corresponding weather icon
    public var icon: String
    
    static let unknown = WeatherCondition(id: 0,
                                          main: "Unknown Weather Condition",
                                          description: "No Description",
                                          icon: "No Icon")
}

/// Type that holds information about recent precipitation
public struct Precipitation: Codable, CustomStringConvertible {
    public var description: String {
        return "Precipitation(lastHour: \(lastHour), lastThreeHours: \(lastThreeHours))"
    }
    
    /// Precipitation volume for the last 1 hour, measured in mm
    public var lastHour: Double { return _1h ?? 0.00 }
    /// Precipitation volume for the last 3 hours, measured in mm
    public var lastThreeHours: Double { return _3h ?? 0.00 }
    
    /// Internal type to handle missing key in JSON response
    private var _1h: Double?
    /// Internal type to handle missing key in JSON response
    private var _3h: Double?
    
    /// Singleton property to indicate there was no precipitation within the last 3 hours
    static let none = Precipitation(_1h: 0, _3h: 0)
    
    enum CodingKeys: String, CodingKey {
        case _1h = "1h"
        case _3h = "3h"
    }
}

/// Type that holds information about cloud coverage
struct Clouds: Codable {
    /// Cloud Coverage measured in percent
    var all: Int
}
