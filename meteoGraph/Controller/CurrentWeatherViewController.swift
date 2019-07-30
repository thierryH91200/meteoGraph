//
//  vc2Controller.swift
//  newGraph2
//
//  Created by thierryH24A on 23/06/2016.
//  Copyright © 2016 thierryH24A. All rights reserved.
//

import AppKit
import Charts
import Quartz
import CoreLocation
//import Alamofire

open class CurrentWeatherViewController: NSViewController
{
    @IBOutlet weak var box: NSView!
    @IBOutlet weak var labelTown: NSTextField!
    
    @IBOutlet weak var clockView: ClockView!
    
    @IBOutlet weak var labelDate: NSTextField!
    
    @IBOutlet weak var labelLever: NSTextField!
    @IBOutlet weak var labelCoucher: NSTextField!
    
    @IBOutlet weak var labelLat: NSTextField!
    @IBOutlet weak var labelLon: NSTextField!
    
    @IBOutlet weak var labelHumidity: NSTextField!
    
    @IBOutlet weak var labelTemperature: NSTextField!
    @IBOutlet weak var labelTemperatureMini: NSTextField!
    @IBOutlet weak var labelTemperatureMaxi: NSTextField!
    
    @IBOutlet weak var labelAirPressure: NSTextField!
    @IBOutlet weak var labelDescription: NSTextField!
    
    @IBOutlet weak var labelVisibility: NSTextField!
    @IBOutlet weak var labelWindDeg: NSTextField!
    @IBOutlet weak var windSpeed: NSTextField!
    
    @IBOutlet weak var labelMain: NSTextField!
    
    @IBOutlet weak var iconWeather: NSImageView!
    @IBOutlet weak var iconCompass: NSImageView!
    
    var photos: [FlickrPhoto] = []
    
    
    //    let internetConnection = InternetConnection()
    
    let apiFlickrKey = "96d2fddc4b9ed903c513bf9aa16ed6e9"
    let secretFlickrKey = "57994500978b8f1e"
    
    
    var image :NSImage = NSImage()
    var clockTimer = ClockTimer(interval: 1.0)
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window!.title = "Current Weather"
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        clockTimer.start { date in
            self.clockView.time = date as NSDate
        }
        
        ConnectOpenWeather()
    }
    
    override open func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive(instance: self, name: .updateTown, selector: #selector(updateChangeTown(_:)))
    }
    
    @objc func updateChangeTown(_ note: Notification) {
        ConnectOpenWeather()
    }
    
    
    func ConnectOpenWeather()
    {
        guard id != "" else {return}
        
        let newApi = HPOpenWeather(apiKey: OpenWeatherAPIKey, temperatureFormat: .celsius, language: .french/*, cnt: 16*/)
        let nameID = id
        let request = CityIdRequest(nameID)
        newApi.requestCurrentWeather(with: request) { (weather, error) in
            
            guard let weather = weather, error == nil else {
                print(error?.localizedDescription ?? "default")
                return;
            }
            
            let location = CLLocationCoordinate2D(latitude: weather.coord.latitude, longitude: weather.coord.longitude)
            FlickrProvider.fetchPhotosForSearchText( location: location, cityName: (weather.name ), cityID: String(weather.id )) { (error: NSError?, flickrPhotos: [FlickrPhoto]?) in
                
                
                if error == nil {
                    self.photos = flickrPhotos!
                }
                
                let results = self.photos.randomElement()
                
                print(results!)
                //                if !results.isEmpty
                //
                DispatchQueue.main.async {

                print("Download Started")
                    let url = results!.photoUrl
                    print(url.absoluteString)
                let data = try? Data(contentsOf: results!.photoUrl)
                    print("Download Finished")
                    print("\(String(describing: data?.description ?? "nil"))")
                    
                    self.backGround1(imageView : NSImage(data: data!)!)
//                }
                }
            }
            
            
            //            self.iconWeather.image = NSImage(named: NSImage.Name( weather.icon + ".png"))
            
            //            var dateFormatter : DateFormatter
            //            dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "EEEE\ndd MMMM"
            //            dateFormatter.timeZone = TimeZone.current
            //            var date2 = Date(timeIntervalSince1970 : TimeInterval(weather?.timeOfCalculation)  )
            //            var date = dateFormatter.string(from: date2)
            
            DispatchQueue.main.async {
                self.labelTown.stringValue = (weather.name)
                self.labelTown.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                var dateFormatter : DateFormatter
                dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE\ndd MMMM"
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "HH:mm"
                
                var date = dateFormatter.string(from: weather.dt)
                self.labelDate.stringValue = date
                self.labelDate.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                date = dateFormatter.string(from: weather.sys.sunrise)
                self.labelLever.stringValue = date
                self.labelLever.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                date = dateFormatter.string(from: weather.sys.sunset)
                self.labelCoucher.stringValue = date
                self.labelCoucher.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelLat.stringValue = "Lattitude : " + String(weather.coord.latitude )
                self.labelLat.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelLon.stringValue = "Longitude : " + String(weather.coord.longitude )
                self.labelLon.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelHumidity.stringValue = "Humidity : " + String(weather.main.humidity ) + " %"
                self.labelHumidity.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelTemperature.stringValue = "Temperature actuelle : " + String(weather.main.temperature ?? 0.0) + " °C"
                self.labelTemperature.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelTemperatureMini.stringValue = "Temperature mini : " + String(weather.main.temperatureMin ) + " °C"
                self.labelTemperatureMini.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelTemperatureMaxi.stringValue = "Temperature maxi : " + String(weather.main.temperatureMax ) + " °C"
                self.labelTemperatureMaxi.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelAirPressure.stringValue = "Pression : " + String(weather.main.pressure ) + " mbar"
                self.labelAirPressure.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelDescription.stringValue = weather.condition.description
                self.labelDescription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelVisibility.stringValue = "Visibilité : " + String(weather.visibility)
                self.labelVisibility.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelWindDeg.stringValue = "Direction du vent : " + String(weather.wind.degrees ) + " °"
                self.labelWindDeg.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.iconCompass.rotate(byDegrees: CGFloat(weather.wind.degrees ))
                self.iconCompass.needsDisplay = true
                
                /// https://fr.wikipedia.org/wiki/Echelle_de_Beaufort
                self.windSpeed.stringValue = "Vitesse du vent : " + String(((weather.wind.speed ) * 3600 ) / 1000 ) + " km/h"
                self.windSpeed.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                self.labelMain.stringValue = weather.condition.description
                self.labelMain.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                if self.parent?.view.layer?.contents  == nil
                {
                    let ima = NSImage(named:NSImage.Name( "background1600.jpg"))
                    self.backGround1(imageView : ima!)
                }
            }
        }
    }
    
    
    func backGround1(imageView : NSImage)
    {
        self.view.wantsLayer = true
//        self.view.layer?.contentsGravity = CALayerContentsGravity(rawValue: CALayerContentsGravity.resizeAspectFill.rawValue)
        self.view.layer?.contents = imageView.CGImage
        self.view.needsDisplay = true
    }
    
    func saveImage(url: String)
    {
        //        let url1 = "http://openweathermap.org/img/w/01n.png"
        //        let url = URL(string: url1)
        //        do {
        //
        //            let data =   try Data(contentsOf: url! , options: .alwaysMapped)
        //
        //            imageURL.image = NSImage(data: data)
        //            let image = NSImage(data: data )
        //            let panel = NSSavePanel()
        //            panel.allowedFileTypes = ["png"]
        //            panel.beginSheetModal(for: self.view.window!) { (result) -> Void in
        //                if result == NSFileHandlingPanelOKButton
        //                {
        //                    if let path = panel.url?.path
        //                    {
        //                        self.save( to: path, image: image!, compressionQuality: 1.0)
        //                    }
        //                }
        //            }
        //
        //        } catch let error
        //        {
        //            print(error.localizedDescription)
        //        }
    }
    
}

extension String
{
    var capitalizeFirst: String
    {
        if self.count == 0
        {
            return self
        }
        
        return String(self[self.startIndex]).capitalized + String(self.dropFirst())
    }
}

extension NSImage {
    func imageRotated(by degrees: CGFloat) -> NSImage {
        let imageRotator = IKImageView()
        var imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        imageRotator.setImage(cgImage, imageProperties: [:])
        imageRotator.rotationAngle = CGFloat(-(degrees / 180) * CGFloat( Double.pi ))
        let rotatedCGImage = imageRotator.image().takeUnretainedValue()
        return NSImage(cgImage: rotatedCGImage, size: NSSize.zero)
    }
}


class FlickrProvider {
    
    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    
    struct Keys {
        static let flickrKey = "YOUR_API_KEY"
    }
    
    let apiFlickrKey = "96d2fddc4b9ed903c513bf9aa16ed6e9"
    let secretFlickrKey = "57994500978b8f1e"
    
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchPhotosForSearchText(location: CLLocationCoordinate2D, cityName: String, cityID: String, onCompletion: @escaping FlickrResponse) -> Void {
        
        let apiFlickrKey = "96d2fddc4b9ed903c513bf9aa16ed6e9"
        //        let secretFlickrKey = "57994500978b8f1e"
        
        var urlComponents = URLComponents(string: "https://api.flickr.com/services/rest/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiFlickrKey),
            
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "accuracy", value: "11"),
            URLQueryItem(name: "per_page", value: "100"),
            
            URLQueryItem(name: "lat", value: String(location.latitude)),
            URLQueryItem(name: "lon", value: String(location.longitude)),
            URLQueryItem(name: "geo_context", value: "2"),
            URLQueryItem(name: "sort", value: "interestingness-desc"),
            URLQueryItem(name: "tags", value: cityName),
            URLQueryItem(name: "tag_mode", value: "all"),
            
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
        ]
        let request = URLRequest(url: urlComponents.url!)
        
        let searchTask = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                onCompletion(error as NSError?, nil)
                return
            }
            do {
                print(data!)
                
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(FilterResult.self, from: data!)
                
//                let photosContainer = gitData.photos
                let photosArray = gitData.photos.photo
                
                let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary.id
                    let farm = photoDictionary.farm
                    let secret = photoDictionary.secret
                    let server = photoDictionary.server
                    let title = photoDictionary.title

                    let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                
                onCompletion(nil, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
            
        })
        searchTask.resume()
    }
    
    
}

public struct Photo: Codable {
    
    let id : String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
}

public struct Photos : Codable {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : String
    let photo : [Photo]
}

public struct FilterResult : Codable {
    let photos : Photos
    let stat : String
}

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_b.jpg")!
        // https://farm66.staticflickr.com/65535/48202739027_d068e63a36_h.jpg

    }
}



