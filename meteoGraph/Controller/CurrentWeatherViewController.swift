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
        
    var image :NSImage = NSImage()
    var clockTimer = ClockTimer(interval: 1.0)
    
    var idOld = ""
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window!.title = "Current Weather"
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        clockTimer.start { date in
            self.clockView.time = date as Date
        }
        ConnectOpenWeather()
    }
    
    override open func viewWillAppear() {
        super.viewWillAppear()
        
        NotificationCenter.receive(instance: self, name: .updateTown, selector: #selector(updateChangeTown(_:)))
    }
    
    @objc func updateChangeTown(_ note: Notification) {
        if id != idOld {
            ConnectOpenWeather()
        }
    }
    
    func ConnectOpenWeather()
    {
        guard id != "" else {return}
        
        idOld = id
        
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
                                
//                FlickrProvider.fetchPhotosForGetSize(photo_id: results!.photoId) {(error: NSError?, flickrPhotos: [SizePhoto]?) in
//
//                    print(flickrPhotos)
//                }
                
                
                DispatchQueue.main.async {
                    print("Download Started")
                    let url = results!.photoUrl
                    let data = try? Data(contentsOf: url)
                    print("Download Finished")
                    
                    self.backGround1(imageView : NSImage(data: data!)!)
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
                
                self.labelLat.stringValue = String(weather.coord.latitude )
                self.labelLat.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelLon.stringValue = String(weather.coord.longitude )
                self.labelLon.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelHumidity.stringValue = String(weather.main.humidity ) + " %"
                self.labelHumidity.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelTemperature.stringValue = String(weather.main.temperature ) + " °C"
                self.labelTemperature.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelTemperatureMini.stringValue = String(weather.main.temperatureMin ) + " °C"
                self.labelTemperatureMini.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelTemperatureMaxi.stringValue = String(weather.main.temperatureMax ) + " °C"
                self.labelTemperatureMaxi.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelAirPressure.stringValue = String(weather.main.pressure ) + " mbar"
                self.labelAirPressure.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelDescription.stringValue = weather.condition.description
                self.labelDescription.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelVisibility.stringValue = String(weather.visibility)
                self.labelVisibility.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.labelWindDeg.stringValue = String(weather.wind.degrees ) + " °"
                self.labelWindDeg.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.iconCompass.rotate(byDegrees: CGFloat(weather.wind.degrees ))
                self.iconCompass.needsDisplay = true
                
                /// https://fr.wikipedia.org/wiki/Echelle_de_Beaufort
                self.windSpeed.stringValue = String(((weather.wind.speed ) * 3600 ) / 1000 ) + " km/h"
                self.windSpeed.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
                self.labelMain.stringValue = weather.condition.description
                self.labelMain.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                if self.parent?.view.layer?.contents  == nil
                {
                    let image = NSImage(named:NSImage.Name( "background1600.jpg"))
                    self.backGround1(imageView : image!)
                }
            }
        }
    }
    
    func backGround1(imageView : NSImage)
    {
        self.view.wantsLayer = true
        self.view.layer?.contentsGravity = CALayerContentsGravity(rawValue: CALayerContentsGravity.resizeAspectFill.rawValue)
        self.view.layer?.contents = imageView.CGImage
//        self.view.needsDisplay = true
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



