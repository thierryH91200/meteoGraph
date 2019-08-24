//
//  Preferences.swift
//  Pine
//
//  Created by Luka Kerr on 29/4/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

typealias BoolPreferenceMap = [String: PreferenceKey<Bool>]


extension PreferenceKeys {
//    static let colorRain = PreferenceKey<Bool>("colorRain", defaultValue: true)
//    static let colorTemperature = PreferenceKey<Bool>("colorReain", defaultValue: true)
//    static let colorPressure = PreferenceKey<Bool>("colorReain", defaultValue: true)
    static let writingDirection = PreferenceKey<Int>("writingDirection", defaultValue: NSWritingDirection.natural.rawValue)
    
    // AppDelegate options
    static let openNewDocumentOnStartup = PreferenceKey<Bool>("openNewDocumentOnStartup", defaultValue: true)
    static let terminateAfterLastWindowClosed = PreferenceKey<Bool>("terminateAfterLastWindowClosed", defaultValue: true)
    
    // Font options
    static let fontSize = PreferenceKey<CGFloat>("fontSize", defaultValue: 14)
    static let fontName = PreferenceKey<String>("fontName", defaultValue: "Courier")
    
}

class Preferences {
    
    static let shared = Preferences()
    let defaults = UserDefaults.standard

    
//    private init() {
//        theme.setFont(to: self.font)
//    }
    
    subscript<T>(key: PreferenceKey<T>) -> T {
        get {
            return self.get(key)
        }
        
        set {
            self.set(key, value: newValue)
        }
    }
    
    /// Get a preference given a key
    public func get<T>(_ preferenceKey: PreferenceKey<T>) -> T {
        guard
            defaults.object(forKey: preferenceKey.key) != nil,
            let value = defaults.object(forKey: preferenceKey.key),
            let typedValue = value as? T
            else {
                return preferenceKey.defaultValue
        }
        
        return typedValue
    }
    
    /// Set a preference given a key and value
    public func set<T>(_ preferenceKey: PreferenceKey<T>, value: Any) {
        defaults.setValue(value, forKey: preferenceKey.key)
    }
    
    /// Given a boolean preference map, a key and value, set the value if found in the map
    public func setFromBoolMap(_ map: BoolPreferenceMap, key: String, value: Bool) {
        if let ext = map[key] {
            self[ext] = value
            NotificationCenter.send(.preferencesChanged)
        }
    }
    
    // MARK: - Dynamic preferences
    
    
    public var font: NSFont {
        get {
            let fontSize = CGFloat(self[.fontSize])
            let fontName = self[.fontName]
            
            if let font = NSFont(name: fontName, size: fontSize) {
                return font
            }
            
            // Default font not found, try to use a few standard ones
            for fontName in ["Courier", "Monaco", "Menlo", "SF Mono"] {
                if let font = NSFont(name: fontName, size: fontSize) {
                    return font
                }
            }
            
            return NSFont.monospacedDigitSystemFont(
                ofSize: fontSize,
                weight: .regular
            )
        }
        
        set {
            self[.fontName] = newValue.fontName
            self[.fontSize] = newValue.pointSize
        }
    }
    
    public var colorTemperature: NSColor {
        get {
                return defaults.color(forKey: "colorTemperature") ?? .blue
        }
        set {
            defaults.set(newValue, forKey: "colorTemperature")
        }
    }
    public var colorRain: NSColor {
        get {
                return defaults.color(forKey: "colorRain") ?? .blue
        }
        set {
            defaults.set(newValue, forKey: "colorRain")
        }
    }
    public var colorPressure: NSColor {
        get {
                return defaults.color(forKey: "colorPressure") ?? .blue
        }
        set {
            defaults.set(newValue, forKey: "colorPressure")
        }
    }

    
    public var writingDirection: NSWritingDirection {
        get {
            let value = self[.writingDirection]
            return NSWritingDirection(rawValue: value) ?? .natural
        }
        
        set {
            self[.writingDirection] = newValue.rawValue
        }
    }
    
}

let preferences = Preferences.shared


extension UserDefaults {
    
    func set(_ color: NSColor, forKey: String) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            self.set(data, forKey: forKey)
        }
    }
    
    func color(forKey: String) -> NSColor? {
        guard
            let storedData = self.data(forKey: forKey),
            let unarchivedData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: storedData),
            let color = unarchivedData as NSColor?
        else {
            return nil
        }
        return color
    }
    
}