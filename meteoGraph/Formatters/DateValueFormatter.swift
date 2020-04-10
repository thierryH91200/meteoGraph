//
//  DateValueFormatter.swift
//  graphPG
//
//  Created by thierryH24A on 20/09/2016.
//  Copyright © 2016 thierryH24A. All rights reserved.
//

import Foundation
import Charts

open class DateFullValueFormatter : NSObject, IAxisValueFormatter
{
    var dateFormatter : DateFormatter
    var miniTime: Double
    var interval: Double
    
    public init(miniTime: Double, interval: Double) {
        //super.init()
        self.miniTime = miniTime
        self.interval = interval
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "dd/MM/yy HH:mm"
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone!
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        self.dateFormatter.dateFormat = "EEEE dd MMM"
        let date2 = Date(timeIntervalSince1970 : ((value * interval) + miniTime)  )
        let date = dateFormatter.string(from: date2)
        return  date
    }
}

