//
//  Weather.swift
//  Dunkel Sky Finder
//
//  Created by Henrik Panhans on 16/01/2017.
//  Copyright © 2017 Henrik Panhans. All rights reserved.
//

import Foundation
import CoreLocation


/**
 {"coord":{"lon":145.77,"lat":-16.92},
 "weather":[{"id":802,"main":"Clouds","description":"scattered  clouds","icon":"03n"}],
 "base":"stations",
 "main":{"temp":300.15,"pressure":1007,"humidity":74,"temp_min":300.15,"temp_max":300.15},
 "visibility":10000,
 "wind":{"speed":3.6,"deg":160},
 "clouds":{"all":40},
 "dt":1485790200,
 "sys":{"type":1,"id":8166,"message":0.2064,"country":"AU","sunrise":1485720272,"sunset":1485766550},
 "id":2172797,
 "name":"Cairns",
 "cod":200}
 */
///

/**
 #coord
     coord.lon City geo location, longitude
     coord.lat City geo location, latitude
 
 #weather (more info Weather condition codes)
     weather.id Weather condition id
     weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
     weather.description Weather condition within the group
     weather.icon Weather icon id
 
 #base Internal parameter
 
 #main
     main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     main.pressure Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
     main.humidity Humidity, %
     main.temp_min Minimum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     main.temp_max Maximum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     main.sea_level Atmospheric pressure on the sea level, hPa
     main.grnd_level Atmospheric pressure on the ground level, hPa
 
 #wind
     wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
     wind.deg Wind direction, degrees (meteorological)
 
 #clouds
    clouds.all Cloudiness, %
 
 #rain
     rain.1h Rain volume for the last 1 hour, mm
     rain.3h Rain volume for the last 3 hours, mm
 
 #snow
     snow.1h Snow volume for the last 1 hour, mm
     snow.3h Snow volume for the last 3 hours, mm
 
 #dt Time of data calculation, unix, UTC
 #sys
     sys.type Internal parameter
     sys.id Internal parameter
     sys.message Internal parameter
     sys.country Country code (GB, JP etc.)
     sys.sunrise Sunrise time, unix, UTC
     sys.sunset Sunset time, unix, UTC
 #timezone Shift in seconds from UTC
 #id City ID
 #name City name
 #cod Internal parameter
 */

/**
 A Codable type that wraps the API response for the current weather request in a usable type
 */
public struct CurrentWeather: Codable  {
    
    /// City geo location
    public var coord : CLLocationCoordinate2D { return _coord! }
    /// more info Weather condition codes
    public var condition: WeatherCondition { return _condition?.first ?? WeatherCondition.unknown }
    
    /// Internal parameter
    public var base : String

    public var main: Main

    /// visibility
    var visibility: Int { return _visibility ?? 0 }
    /// Wind
    public var wind: Wind
    /// Clouds
    public var cloudCoverage: Int { return _clouds?.all ?? 0 }

    public var rain: Precipitation { return _rain ?? Precipitation.none }
    public var snow: Precipitation { return _snow ?? Precipitation.none }
    
    public var dt: Date

    public var sys: System { return _system! }
    
    public var timezone: Int
    public var name: String
    public var id: Int


    /// The location coordinates of the request
    internal var _coord: CLLocationCoordinate2D?
    /// Internal property to handle array in JSON response that shouldn't be an array lol
    internal var _condition: [WeatherCondition]?

/// Holds information about sunset und sunrise times in UTC time at the location of the request
    internal var _system: System?
    
    /// Internal property to handle missing "rain" key in JSON reponse
    internal var _rain: Precipitation?
    /// Internal property to handle missing "snow" key in JSON reponse
    internal var _snow: Precipitation?

    /// Internal property to handle missing "clouds" key in JSON reponse
    internal var _clouds: Clouds?
    /// Internal property to handle missing "_visibility" key in JSON reponse
    internal var _visibility: Int?

}

extension CurrentWeather {
    enum CodingKeys: String, CodingKey {
        
        case _coord     = "coord"
        case _condition = "weather"
        
        case base       = "base"
        case main       = "main"
        
        case _visibility = "visibility"
        
        case wind       = "wind"
        case _clouds    = "clouds"

        case _rain      = "rain"
        case _snow      = "snow"
        
        case dt         = "dt"
        
        case _system    = "sys"
        
        case timezone   = "timezone"
        case name       = "name"
        case id         = "id"
    }

}
