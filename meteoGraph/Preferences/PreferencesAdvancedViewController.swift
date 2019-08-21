//
//  PreferencesAdvancedViewController.swift
//  SwiftPrefs
//
//  Created by Adrian Sluijters on 04/02/2016.
//  Copyright © 2016 Flixel Photos Inc. All rights reserved.
//

import AppKit

protocol FooViewDelegate{
    func itemWithIndexWasSelected(value:Int)
}


class PreferencesAdvancedViewController: NSViewController, Preferenceable {
    
    let defaults = UserDefaults.standard
    
//    private let appearanceMap: BoolPreferenceMap = [
//      "colorRain": .colorRain
//    ]


    
    let toolbarItemTitle = "Advanced"
    let toolbarItemIcon = NSImage(named: NSImage.everyoneName)!
    
    var delegate: FooViewDelegate?

    @IBOutlet weak var languagePopUp: NSPopUpButton!
    @IBOutlet weak var colorRain: NSColorWell!
    @IBOutlet weak var colorTemperature: NSColorWell!
    @IBOutlet weak var colorPressure: NSColorWell!

    let language = ["english", "russian", "italian", "spanish", "ukrainian", "german", "portuguese", "romanian",
                    "polish", "finnish", "dutch", "french", "bulgarian", "swedish", "chineseTraditional", "chineseSimplified",
                    "turkish", "croatian", "catalan"]

    let Defaults = UserDefaults.standard
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
       
        setupData()
    }
    
    func setupData()
    {
        colorRain.color = preferences.colorRain
        colorTemperature.color = preferences.colorTemperature
        colorPressure.color = preferences.colorPressure

        languagePopUp.removeAllItems()
        languagePopUp.addItems(withTitles: language)
        languagePopUp.target = self
        languagePopUp.action = #selector(myPopUpButtonWasSelected(_:))
    }
    
    @IBAction func deleteAllPreferencesAction(_ sender: Any) {
        print("Button: \(#function)")
    }
    
    @objc @IBAction func myPopUpButtonWasSelected(_ sender:Any) {
        
        let title = languagePopUp.titleOfSelectedItem!
        
        if let mindex = language.firstIndex(of: title) {
            self.delegate?.itemWithIndexWasSelected(value: mindex)
        }
    }

    @IBAction func actionRain(_ sender: NSColorWell) {
        preferences.colorRain = sender.color
    }
    @IBAction func actionTemperature(_ sender: NSColorWell) {
        preferences.colorTemperature = sender.color
    }
    @IBAction func actionPressure(_ sender: NSColorWell) {
        preferences.colorPressure = sender.color
    }

}

