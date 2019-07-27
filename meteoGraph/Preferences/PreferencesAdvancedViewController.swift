//
//  PreferencesAdvancedViewController.swift
//  SwiftPrefs
//
//  Created by Adrian Sluijters on 04/02/2016.
//  Copyright © 2016 Flixel Photos Inc. All rights reserved.
//

import AppKit

class PreferencesAdvancedViewController: NSViewController, Preferenceable {
    
    let toolbarItemTitle = "Advanced"
    let toolbarItemIcon = NSImage(named: NSImage.everyoneName)!

    let Defaults = UserDefaults.standard
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
       
        setupData()
    }
    
    
    func setupData()
    {
        

    }
    
    @IBAction func deleteAllPreferencesAction(_ sender: Any) {
        print("Button: \(#function)")
    }
    
}

