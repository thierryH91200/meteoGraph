//
//  PreferencesAdvancedViewController.swift
//  SwiftPrefs
//
//  Created by Adrian Sluijters on 04/02/2016.
//  Copyright © 2016 Flixel Photos Inc. All rights reserved.
//

import AppKit

final class PreferencesUnitViewController: NSViewController, Preferenceable {
    
    private let echelleMap: BoolPreferenceMap = [
        "echelleAutomatique": .echelleAutomatique,
        "echelleManuelle": .echelleManuelle
    ]

    let toolbarItemTitle = "Unit"
    let toolbarItemIcon = NSImage(named: NSImage.listViewTemplateName)!

    let Defaults = UserDefaults.standard
    
    @IBOutlet var deleteAllPreferencesButton: NSButton!
    
    
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
    }
    
    @IBAction func radioButtonChanged(_ sender: NSButton)
    {
        preferences.setFromBoolMap(echelleMap, key: sender.title, value: sender.value)
        NotificationCenter.send(.preferencesChanged)
    }
    
    
    @IBAction func buttonValide(_ sender: Any) {
        preferences[.temperatureMini] = temperatureMini.doubleValue
        preferences[.temperatureMaxi] = temperatureMaxi.doubleValue
        
        preferences[.pressionMini] = pressionMini.doubleValue
        preferences[.pressionMaxi] = pressionMaxi.doubleValue

        preferences[.hauteurPluieMini] = hauteurMini.doubleValue
        preferences[.hauteurPluieMaxi] = hauteurMaxi.doubleValue
        
        NotificationCenter.send(.preferencesChanged)

    }
}
extension NSButton {

  var value: Bool {
    return self.state.rawValue != 0 ? true : false
  }

}


