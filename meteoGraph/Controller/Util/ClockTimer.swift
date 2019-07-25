//
// Created by Mikael Hallendal on 16/05/15.
// Copyright (c) 2015 Mikael Hallendal. All rights reserved.
//

import Foundation

class ClockTimer {
    let interval: TimeInterval
    var timer: DispatchSource?
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    func start(_ callback: @escaping (Date) -> ())
    {
        if let t = timer
        {
            t.cancel()
        }
        // Value of type 'DispatchSourceTimer' has no member 'setTimer'
        let timer1 = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main)
        _ = DispatchTime.now() + Double(Int64(interval)) / Double(NSEC_PER_SEC)
        
        timer1.schedule(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(100000)), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))

        timer1.setEventHandler { callback(Date()) }
        timer1.resume()
        
        timer = timer1 as? DispatchSource
    }
    
    func stop()
    {
        if let t = timer {
            t.cancel()
        }
        
        timer = nil
    }
}
