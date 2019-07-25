//
// Created by Mikael Hallendal on 16/05/15.
// Copyright (c) 2015 Mikael Hallendal. All rights reserved.
//

import Foundation
import AppKit

class ClockView: NSView {
    
    var clockFace: CATextLayer?
    
    var time: NSDate = NSDate() {
        didSet {
            clockFace?.string = formatter.string(from: time as Date)
        }
    }
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMM HH:mm:ss"
        formatter.timeZone = NSTimeZone.system
        return formatter
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer = setupLayers()
    }
    
    func setupLayers() -> CALayer
    {
        let backgroundLayer = setupBackgroundLayer()
        
        clockFace = setupClockFaceLayer()
        
        backgroundLayer.addSublayer(clockFace!)
        backgroundLayer.addSublayer(setupBorderLayer())
        backgroundLayer.addSublayer(setupGlossLayer())
        
        return backgroundLayer
    }
    
    func setupBackgroundLayer() -> CALayer
    {
        let gradientLayer = CAGradientLayer()
        
//       let gradientColor1 = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
//        let gradientColor2 = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).cgColor
//        
//        gradientLayer.colors = [gradientColor1, gradientColor2]
//        gradientLayer.cornerRadius = 12.0
        
        gradientLayer.layoutManager = CAConstraintLayoutManager()
        
        return gradientLayer
    }
    
    func setupClockFaceLayer() -> CATextLayer {
        let clockFace = CATextLayer()
        
        clockFace.font = "Menlo" as CFTypeRef
        clockFace.fontSize = 32.0
        clockFace.shadowOpacity = 0.5
        clockFace.allowsFontSubpixelQuantization = true
        clockFace.foregroundColor = CGColor(red: 13.0/255.0, green: 116.0/255.0, blue: 1.0, alpha: 1.0)
        
        clockFace.addConstraint(constraint(attribute: .midX, relativeTo: "superlayer", attribute2: .midX))
        clockFace.addConstraint(constraint(attribute: .midY, relativeTo: "superlayer", attribute2: .midY))
        
        clockFace.string = formatter.string(from: time as Date)
        
        return clockFace
    }
    
    func setupBorderLayer() -> CALayer
    {
        let border = CALayer()
        
        border.cornerRadius = 12.0
        border.borderColor = NSColor.red.cgColor
        border.borderWidth = 2.0
        
        //       border.frame = frame.insetBy(dx: 8.0, dy: 8.0)
        
        return border
    }
    
    func setupGlossLayer() -> CALayer {
        let gloss = CALayer()
        
        if let image = NSImage(named: NSImage.Name( "Gloss")) {
            gloss.contents = image.CGImage
        }
        
        gloss.opacity = 0.8
        gloss.cornerRadius = 12.0
        gloss.masksToBounds = true
        
        gloss.frame = frame
        
        return gloss
    }
}

func constraint(attribute: CAConstraintAttribute, relativeTo: String, attribute2: CAConstraintAttribute) -> CAConstraint
{
    return CAConstraint(attribute: attribute, relativeTo: relativeTo, attribute: attribute2)
}
//'constraintWithAttribute(_:relativeTo:attribute:)' is unavailable: use object construction 'CAConstraint(attribute:relativeTo:attribute:)'
extension NSImage {
    var CGImage: CGImage {
        let imageSource = CGImageSourceCreateWithData(self.tiffRepresentation! as CFData, nil)
        return CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)!
    }
}



















