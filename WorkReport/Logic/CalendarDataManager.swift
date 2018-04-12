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

//print(Date().startOfMonth())     // "2018-02-01 08:00:00 +0000\n"
//print(Date().endOfMonth())       // "2018-02-28 08:00:00 +0000\n"

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
    
    func initCalendar (){
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            readEvents()
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    self.readEvents()
                }else{
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func readEvents(title : String = "Work", sourceTitle : String = "iCloud") {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if (calendar.title == title &&
                calendar.source.title == sourceTitle) {
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                let calendarArray: [EKCalendar] = [calendar]
                let predicate2 = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end : oneMonthAfter as Date, calendars: calendarArray)
                
                print("startDate:\(oneMonthAgo) endDate:\(oneMonthAfter)")
                let eV = eventStore.events(matching: predicate2) as [EKEvent]?
                
                if eV != nil {
                    for i in eV! {
                        print("Title  \(i.title)" )
                        print("stareDate: \(i.startDate)" )
                        print("endDate: \(i.endDate)" )
                        
                        if i.title == "Test Title" {
                            print("YES" )
                            // Uncomment if you want to delete
                            //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                        }
                    }
                }
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

