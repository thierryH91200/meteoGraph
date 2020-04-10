//
//  DateValueFormatter.swift
//  graphPG
//
//  Created by thierryH24A on 20/09/2016.
//  Copyright © 2016 thierryH24A. All rights reserved.
//

import Foundation
import Charts

open class DateValueFormatter : NSObject, IAxisValueFormatter
{
    var dateFormatter : DateFormatter
    var miniTime: Double
    var interval: Double
    var dateStep: String
    
    public init(miniTime: Double, interval: Double, dateStep: String) {
        //super.init()
        self.miniTime = miniTime
        self.interval = interval
        self.dateStep = dateStep
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yy HH:mm"
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        self.dateFormatter.dateFormat = "HH:mm"
        let date2 = Date(timeIntervalSince1970 : ((value * interval) + miniTime)  )
        var date = dateFormatter.string(from: date2)
        if date == dateStep
        {
            self.dateFormatter.dateFormat = "EEEE dd MMM HH:mm"
            date = dateFormatter.string(from: date2)
        }
        return  date
    }
}

