//
//  EnterDate.swift
//  KKEvents
//
//  Created by Southard Dylan on 15/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import EventKit

open class EnterDate: NSObject {
    var eventSaved = false
    
    var savedEventId : String = ""
    
    
    func requestAccessPermission(_ title:String, startDate:Date, endDate:Date, place:String)->Bool {
        
        let eventStore = EKEventStore()
        
        
        
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore, title: title, startDate: startDate, endDate: endDate, place:place)
                
            })
        } else {
            createEvent(eventStore, title: title, startDate: startDate, endDate: endDate, place: place)
        }
        
        
        return self.eventSaved
    }
    
    
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date, place:String) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        let alarm:EKAlarm = EKAlarm(relativeOffset: -60*60*6)
        event.alarms = [alarm]
        event.location = place
        
        
        do {
            
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
            self.eventSaved = true
            
        } catch {
            self.eventSaved = false
            
        }
        
        
    }
    
    
    
}
