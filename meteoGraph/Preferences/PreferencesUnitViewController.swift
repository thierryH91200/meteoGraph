//
//  PreferencesAdvancedViewController.swift
//  SwiftPrefs
//
//  Created by Adrian Sluijters on 04/02/2016.
//  Copyright © 2016 Flixel Photos Inc. All rights reserved.
//

import AppKit

final class PreferencesUnitViewController: NSViewController, Preferenceable {
    
    let toolbarItemTitle = "Unit"
    let toolbarItemIcon = NSImage(named: NSImage.listViewTemplateName)!

    let Defaults = UserDefaults.standard
    
    @IBOutlet var deleteAllPreferencesButton: NSButton!
    
    @IBOutlet weak var temperatureSegment: NSSegmentedControl!
    @IBOutlet weak var hauteurSegement: NSSegmentedControl!
    @IBOutlet weak var popupVitesse: NSPopUpButton!
    
    @IBOutlet weak var temperatureMini: NSTextField!
    @IBOutlet weak var temperatureMaxi: NSTextField!
    
    @IBOutlet weak var pressionMini: NSTextField!
    @IBOutlet weak var pressionMaxi: NSTextField!
    
    @IBOutlet weak var hauteurMini: NSTextField!
    @IBOutlet weak var hauteurMaxi: NSTextField!
    
    @IBOutlet weak var automatique: NSButton!
    @IBOutlet weak var manuelle: NSButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupData()
        buttonValide(deleteAllPreferencesButton!)
    }
    
    func setupData()
    {
        let settings = [
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
            ] as [String         : Any]
        
        Defaults.register(defaults: settings)
        
        var val = Defaults.integer(forKey: "EchelleAutomatique")
        automatique.state = NSControl.StateValue(rawValue: val)
        
        val = Defaults.integer(forKey: "EchelleManuelle")
        manuelle.state = NSControl.StateValue(rawValue: val)
        
        temperatureMini.doubleValue = preferences[.temperatureMini]
        temperatureMaxi.doubleValue = preferences[.temperatureMaxi]
        
        pressionMini.doubleValue = preferences[.pressionMini]
        pressionMaxi.doubleValue = preferences[.pressionMaxi]

        hauteurMini.doubleValue = preferences[.hauteurPluieMini]
        hauteurMaxi.doubleValue = preferences[.hauteurPluieMaxi]
    }
    
    @IBAction func deleteAllPreferencesAction(_ sender: Any) {
        print("Button: \(#function)")
        
        UserDefaults.resetStandardUserDefaults()
        automatique.state = NSControl.StateValue(rawValue: 1)
        temperatureSegment.setSelected(true, forSegment: 0)
        hauteurSegement.setSelected(true, forSegment: 0)
    }
    
    @IBAction func radioButtonChanged(_ sender: Any)
    {
        Defaults.set(automatique.state , forKey: "EchelleAutomatique")
        Defaults.set(manuelle.state, forKey: "EchelleManuelle")
    }
    
    @IBAction func temperareIndex(_ sender: Any) {
        Defaults.set(temperatureSegment.selectedSegment, forKey: "uniteTemperature")
    }
    
    @IBAction func hauteurIndex(_ sender: Any) {
        Defaults.set(hauteurSegement.selectedSegment, forKey: "uniteHauteurPluie")
    }
    
    @IBAction func vitesseIndex(_ sender: Any) {
         Defaults.set(popupVitesse.indexOfSelectedItem, forKey: "uniteVitesse")
    }
    
    @IBAction func buttonValide(_ sender: Any) {
        preferences[.temperatureMini] = temperatureMini.doubleValue
        preferences[.temperatureMaxi] = temperatureMaxi.doubleValue
        
        preferences[.pressionMini] = pressionMini.doubleValue
        preferences[.pressionMaxi] = pressionMaxi.doubleValue

        preferences[.hauteurPluieMini] = hauteurMini.doubleValue
        preferences[.hauteurPluieMaxi] = hauteurMaxi.doubleValue
    }
}

