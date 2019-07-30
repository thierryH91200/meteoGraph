//
//  CurrentWeatherView.swift
//  iComptaGraph
//
//  Created by thierryH24A on 04/03/2017.
//  Copyright © 2017 thierryH24A. All rights reserved.
//

import AppKit

class CurrentWeatherView: NSView {
    
    var initialLocation = NSPoint()
    
    override func draw(_ dirtyRect: NSRect) {
        
        wantsLayer = true
        layer?.contents = NSColor.clear
        NSColor.clear.setFill()
        super.draw(dirtyRect)
        
                let colorTop = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
                let colorBottom = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                let gradient = NSGradient(colors: [colorTop, colorBottom])
                gradient?.draw(in: dirtyRect, angle: 45)
    }
    
    // -------------------- MOUSE EVENTS ------------------- \\
    override func acceptsFirstMouse(for e: NSEvent?) -> Bool {
        window?.isMovableByWindowBackground = true
        return true
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        let windowFrame: NSRect? = self.window?.frame
        
        initialLocation = NSEvent.mouseLocation
        initialLocation.x -= (windowFrame?.origin.x)!
        initialLocation.y -= (windowFrame?.origin.y)!
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
        var currentLocation: NSPoint
        var newOrigin = NSPoint()
        let screenFrame: NSRect = NSScreen.main!.frame
        let windowFrame: NSRect = self.frame
        currentLocation = NSEvent.mouseLocation
        
        newOrigin.x = currentLocation.x - initialLocation.x
        newOrigin.y = currentLocation.y - initialLocation.y
        
        // Don't let window get dragged up under the menu bar
        if (newOrigin.y + windowFrame.size.height) > (screenFrame.origin.y + screenFrame.size.height) {
            newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height)
        }
        //go ahead and move the window to the new location
        self.window?.setFrameOrigin(newOrigin)
    }
    
}
