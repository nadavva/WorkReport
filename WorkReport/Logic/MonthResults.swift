//
//  MonthResults.swift
//  WorkReport
//
//  Created by Nadav Vanunu on 02/05/2018.
//  Copyright © 2018 Nadav Vanunu. All rights reserved.
//

import Foundation
import EventKit

class MonthResults {
    var days : Array<DayResults?>
    let month : Int
    let year : Int
    
    init(month: Int, year: Int, daysInMonth: Int) {
        self.days = [DayResults?](repeating: nil, count: daysInMonth)
        self.month = month
        self.year = year
    }
    
    func addEvent(event: EKEvent, forDay: Int) {
        if (self.days[forDay - 1] == nil) {
            self.days[forDay - 1] = DayResults()
        }
        self.days[forDay-1]?.events.append(event)
    }
    
    func printResults() {

        for day in self.days {
            print("printing events for day: " + self.days.index(of: day))
        }
    }
}


class DayResults {
    
    var events: Array<EKEvent>
    
    init() {
        self.events = Array()
    }
    
    func didWork() -> Bool {
        return false;
        // TODO: missing implementation
    }
    
    func isHoliday() -> Bool {
        return false;
        // TODO: missing implementation
    }
    
    func totalWorkHours() -> Double {
        return 0;
        // TODO: missing implementation
    }
    
    
}
