//
//  CalendarDataManager.swift
//  WorkReport
//
//  Created by Nadav Vanunu on 10/04/2018.
//  Copyright © 2018 Nadav Vanunu. All rights reserved.
//

import Foundation
import EventKit


extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}


final class CalendarDataManager {
    
    static let sharedInstance = CalendarDataManager()
    
    private init() {
    }
    
    func lastDayForMonth(month : Int, year: Int) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let start = String(year) + "/" + String(month) + "/01 00:00" //"2016/10/08 00:00"
        let startDateTime : Date = formatter.date(from: start)!
        
        let last = startDateTime.endOfMonth()
        let day = Calendar.current.component(.day, from: last)
        print("Last day for date ",month, "/",year," = ",day)
        return day
    }
    
    func initCalendarWith(month : Int, year: Int){
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            readCalendarEvents(forMonth: month, andYear: year)
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    self.readCalendarEvents(forMonth: month, andYear: year)
                }else{
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func readCalendarEvents(forMonth : Int, andYear: Int, title : String = "Work", sourceTitle : String = "iCloud") {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if (calendar.title == title &&
                calendar.source.title == sourceTitle) {
                
                // Initialize Date components
                var c = DateComponents()
                c.year = andYear
                c.month = forMonth
                c.day = 1
                
                // Get NSDate given the above date components
                // TODO: need to create the date in the current timeZone, from current code I get
                let fromDate = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c)
                
                c = DateComponents()
                c.year = andYear
                c.month = forMonth
                
                // calculate month length
                let daysInMonth = self.lastDayForMonth(month: forMonth, year: andYear)
                c.day = daysInMonth
                let toDate = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c)
                
                print(toDate ?? "") //Convert String to Date
                

                let calendarArray: [EKCalendar] = [calendar]
                let predicate2 = eventStore.predicateForEvents(withStart: fromDate!, end : toDate!, calendars: calendarArray)
                
                print("Collecting events - startDate:\(fromDate), endDate:\(toDate)")
                let eV = eventStore.events(matching: predicate2) as [EKEvent]?
                
                if eV != nil {
                    // we have data
                    let results = MonthResults(month: forMonth, year: andYear, daysInMonth: daysInMonth)
                    for i in eV! {
                        
                        let event : EKEvent = i
                        print("Title  \(event.title)" )
                        let eventDay = NSCalendar.current.component(.day, from: event.startDate)
                        results.addEvent(event: event, forDay: eventDay)
                    }
                }
                
                print("Done with events")
            }
        }
        
        
    }
    
    func getTargetCalendar(title : String, sourceTitle : String) -> EKCalendar? {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if (calendar.title == title &&
                calendar.source.title == sourceTitle) {
                return calendar
            }
        }
        return nil
    }
    

}

