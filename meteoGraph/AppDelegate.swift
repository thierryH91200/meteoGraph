//
//  AppDelegate.swift
//  meteoGraph
//
//  Created by thierry hentic on 24/07/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

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
        
        mainWindowController = MainWindowController(windowNibName: NSNib.Name( "MainWindowController"))
        mainWindowController?.showWindow(self)
    }
    


}

