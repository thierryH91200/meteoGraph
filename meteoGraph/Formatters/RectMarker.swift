//
//  RectMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts

open class RectMarker: MarkerImage
{
    open var color: NSUIColor?
    open var font: NSUIFont?
    open var insets = NSEdgeInsets()
    
    open var miniTime : Double = 0.0
    var interval = 3600.0 * 24.0
    
    open var minimumSize = CGSize()
    var dateFormatter = DateFormatter()
    
    fileprivate var label: NSMutableAttributedString?
    fileprivate var _labelSize: CGSize = CGSize()
    
    public init(color: NSUIColor, font: NSUIFont, insets: NSEdgeInsets, miniTime: Double = 0.0, interval: Double = 0.0)
    {
        super.init()
        
        self.color = color
        self.font = font
        self.insets = insets
        self.miniTime = miniTime
        self.interval = interval
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")! as TimeZone
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = CGPoint() //CGPoint(x: 10.0, y:10.0)
        let chart = self.chartView
        var size = self.size
        
        if size.width == 0.0 && image != nil
        {
            size.width = image?.size.width ?? 0.0
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image?.size.height ?? 0.0
        }
        
        let width = size.width
        let height = size.height
        let origin = point
        
        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x
        }
        else if chart != nil && origin.x + width + offset.x > chart!.viewPortHandler.contentRect.maxX
        {
            offset.x =  -width
        }
        
        if origin.y + offset.y < 0
        {
            offset.y = height
        }
        else if chart != nil && origin.y + height + offset.y > chart!.viewPortHandler.contentRect.maxY
        {
            offset.y =  -height
        }
        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        let rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        
        context.saveGState()
        if let color = color
        {
            context.setFillColor(color.cgColor)
            context.beginPath()
            context.addRect(rect)
            context.fillPath()
        }
        label.draw(in: rect)
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        var str = ""
        let mutableString = NSMutableAttributedString( string: str )
        
        let chartView = self.chartView
        var dataEntry = [ChartDataEntry]()
        for  dataSets in chartView!.data!.dataSets
        {
            dataEntry = dataSets.entriesForXValue(entry.x)
            let label = dataSets.label
            
            if !dataEntry.isEmpty
            {
                let data = dataSets.valueFormatter.stringForValue(dataEntry[0].y, entry: dataEntry[0], dataSetIndex: 0, viewPortHandler: nil)
                str = label! + " : " + data + "\n"
            }
            else
            {
                str = label! + " :\n"
            }
            
            let labelAttributes:[NSAttributedString.Key: Any]? = [
                NSAttributedString.Key.font : NSFont( name: "Georgia",  size: 12.0)!,
                NSAttributedString.Key.foregroundColor : dataSets.colors[0]]
            
            mutableString.setAttributes([NSAttributedString.Key.font : NSFont( name: "Georgia",  size: 12.0)!,
                                         NSAttributedString.Key.foregroundColor : dataSets.colors[0]], range: NSMakeRange(0, mutableString.length))
            
            let addedString = NSAttributedString(string: str, attributes: labelAttributes)
            mutableString.append(addedString)
        }
        
        str = "\nDate : " + stringForValue( dataEntry[0].x )
        let labelAttributes:[NSAttributedString.Key : Any]? = [
            NSAttributedString.Key.font : NSFont( name: "Georgia",  size: 12.0)!,
            NSAttributedString.Key.foregroundColor : NSUIColor.black ]
        
        let addedString = NSAttributedString(string: str, attributes: labelAttributes)
        mutableString.append(addedString)
        setLabel(mutableString)
    }
    
    open func setLabel(_ newlabel: NSMutableAttributedString)
    {
        label = newlabel
        _labelSize = label!.size()
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
    func stringForValue(_ value: Double) -> String
    {
        self.dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        let date2 = Date(timeIntervalSince1970 : ((value * interval) + miniTime)  )
        let date = dateFormatter.string(from: date2)
        return  date
    }
    
}














