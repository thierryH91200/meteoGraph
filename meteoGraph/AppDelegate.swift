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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        initializeLibraryAndShowMainWindow()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc(applicationShouldTerminateAfterLastWindowClosed:) func applicationShouldTerminateAfterLastWindowClosed (_ sender: NSApplication) -> Bool
    {
        return true
    }


    @IBAction func showPreferencesWindow(_ sender: NSObject?){
//        self.preferencesWindowController.showWindow(self)
    }
    
    func initializeLibraryAndShowMainWindow() {
        
        if !UserDefaults.standard.bool(forKey: DEFAULTS_ARE_INITIALIZED_STRING)  {
            
            UserDefaults.standard.set(true, forKey: DEFAULTS_ARE_INITIALIZED_STRING)
            UserDefaults.standard.setValuesForKeys(DEFAULTS_INITIAL_DEFAULTS)
        }

        
        mainWindowController = MainWindowController(windowNibName: NSNib.Name( "MainWindowController"))
        mainWindowController?.showWindow(self)
    }
    


}

