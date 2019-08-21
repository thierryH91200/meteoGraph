//
//  AppDelegate.swift
//  meteoGraph
//
//  Created by thierry hentic on 24/07/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

let DEFAULTS_ARE_INITIALIZED_STRING = "importantDefaultsAreInitialized"

let DEFAULTS_INITIAL_DEFAULTS: [String : Any] = [
    "EchelleAutomatique" : 1,
    "EchelleManuelle"    : 0,
    "temperatureMini"    : -10.0,
    "temperatureMaxi"    : 40.0,
    "pressionMini"       : 960.0,
    "pressionMaxi"       : 1040.0,
    "hauteurPluieMini"   : 0.0,
    "hauteurPluieMaxi"   : 40.0,
    "uniteTemperature"   : 0,
    "uniteVitesse"       : 0,
    "uniteHauteurPluie"  : 0
]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: MainWindowController?
    var cities = [Cities]()
    var sectionsCity =  [Section]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initializeLibraryAndShowMainWindow()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed (_ sender: NSApplication) -> Bool
    {
        return preferences[.terminateAfterLastWindowClosed]
    }
    
    func initializeLibraryAndShowMainWindow() {
        
        checkForBirthday()
        
        if !UserDefaults.standard.bool(forKey: DEFAULTS_ARE_INITIALIZED_STRING)  {
            
            UserDefaults.standard.set(true, forKey: DEFAULTS_ARE_INITIALIZED_STRING)
            UserDefaults.standard.setValuesForKeys(DEFAULTS_INITIAL_DEFAULTS)
            cities = UtilCity.shared.loadJson(name: "city.default")
            UtilCity.shared.saveCity(arrayCity: cities)
            
            let item = [Item]()
            let town = Item (name:"Town", icon: "city")
            
            let section1 = Section(section: town, item: item)
            
            for i in 0..<cities.count {
                let name = Flag.of(code:cities[i].country ) + " " + (cities[i].name )
                
                let city = Item(name: name, icon:"01d", nameView: "City", id: String(cities[i].id ), badge: "0", colorBadge: .blue)
                city.icon = ""
                city.isBadgeHidden = true
                
                section1.item.append(city)
            }
            sectionsCity.append(section1)
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let data = try encoder.encode(sectionsCity)
                UserDefaults.standard.set(data, forKey: "town")
                
            } catch {
                print("error: ", error)
            }
        }
        
        mainWindowController = MainWindowController(windowNibName: NSNib.Name( "MainWindowController"))
        mainWindowController?.showWindow(self)
    }
    
    // MARK: - Easter Eggs
    func checkForBirthday()
    {

        let components = NSCalendar.current.dateComponents([.month, .day], from:Date())
      if (components.month == 8 && components.day == 3) {
        let  app = NSApplication.shared
        let appIcon = app.applicationIconImage
        app.applicationIconImage = self.editionColoredImage( image: appIcon!)
      }
    }

    func editionColoredImage(image : NSImage ) -> NSImage
    {
        return self.imageWithHueAdjust(image: image,  colorValue:365.375)
        
        
    }

    func imageWithHueAdjust(image :NSImage,  colorValue:Double) ->NSImage
    {
        let inputImage = CIImage( data:image.tiffRepresentation!)

        let hueAdjust = CIFilter( name: "CIHueAdjust")
        
        hueAdjust?.setValue(inputImage, forKey: "inputImage")   //( inputImage!, forKey: "inputImage")
        hueAdjust?.setValue(colorValue, forKey: "inputAngle")

        let outputImage = hueAdjust?.outputImage
        let resultImage = NSImage( size:(outputImage?.extent.size)!)
        let rep = NSCIImageRep( ciImage:outputImage!)
        resultImage.addRepresentation(rep)

      return resultImage;
    }
}

