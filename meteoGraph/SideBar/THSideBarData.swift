//
//  SideBarData.swift
//  SideBarDemo
//
//  Created by thierryH24 on 25/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import AppKit

public class Item : Codable {
    
    var name: String
    var nameView: String
    var id: String
    var icon : String
    var isIconHidden : Bool
    var badge: String
    var colorBadge : NSColor
    var isBadgeHidden : Bool
    
    var image: NSImage? {
        return NSImage(named: NSImage.Name(icon))
    }

    init(name: String, icon: String,  nameView : String, id : String = "", badge : String, colorBadge : NSColor) {
        self.name       = name
        self.nameView   = nameView
        self.icon       = icon
        self.isIconHidden = false
        self.badge      = badge
        self.colorBadge = colorBadge
        self.isBadgeHidden   = false
        self.id         = id
    }
    
    init(name: String, icon: String) {
        self.name       = name
        self.nameView   = ""
        self.icon       = icon
        self.isIconHidden = false
        self.badge      = ""
        self.colorBadge = .blue
        self.isBadgeHidden  = false
        self.id = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case name       = "name"
        case nameView   = "nameView"
        case id         = "id"
        case icon       = "icon"
        case isIconHidden = "isIconHidden"
        case badge      = "badge"
        case colorBadge = "colorBadge"
        case isBadgeHidden = "isBadgeHidden"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name          = try container.decode(String.self, forKey: .name)
        nameView      = try container.decode(String.self, forKey: .nameView)
        id            = try container.decode(String.self, forKey: .id)
        icon          = try container.decode(String.self, forKey: .icon)
        isIconHidden  = try container.decode(Bool.self, forKey: .isIconHidden)
        badge         = try container.decode(String.self, forKey: .badge)
        colorBadge    = try container.decode(Color.self, forKey: .colorBadge).uiColor
        isBadgeHidden = try container.decode(Bool.self, forKey: .isBadgeHidden)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(nameView, forKey: .nameView)
        try container.encode(id, forKey: .id)
        try container.encode(icon, forKey: .icon)
        try container.encode(isIconHidden, forKey: .isIconHidden)
        try container.encode(badge, forKey: .badge)
        try container.encode(Color(uiColor: colorBadge), forKey: .colorBadge)
        try container.encode(isBadgeHidden, forKey: .isBadgeHidden)
    }
}

class Section : Codable {
    
    var section : Item
    var item : [Item]
    
    init(section: Item, item: [Item]) {
        self.section = section
        self.item = item
    }
    
    enum CodingKeys: String, CodingKey {
        case item = "item"
        case section = "section"
    }
    
}

public class Color : Codable {
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor : NSColor {
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor : NSColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

extension Section: Equatable {
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.section.name == rhs.section.name &&
            lhs.section.nameView == rhs.section.nameView &&
            lhs.section.icon == rhs.section.icon
    }
}
