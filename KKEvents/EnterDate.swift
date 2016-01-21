//
//  EnterDate.swift
//  KKEvents
//
//  Created by Southard Dylan on 15/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import EventKit

public class EnterDate: NSObject {
    var alertController = UIAlertController()
    
    var savedEventId : String = ""
    
    
    func requestAccessPermission(title:String, startDate:NSDate, place:String)->UIAlertController {
        let eventStore = EKEventStore()
        
    
        let endDate = startDate.dateByAddingTimeInterval(60 * 60) // Ends one hour later
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: title, startDate: startDate, endDate: endDate, place:place)
                
            })
        } else {
            createEvent(eventStore, title: title, startDate: startDate, endDate: endDate, place: place)
        }
        return self.alertController
    }
    
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate, place:String) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        let alarm:EKAlarm = EKAlarm(relativeOffset: -60*60*6)
        event.alarms = [alarm]
        event.location = place
        
        
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
            self.alertController = UIAlertController(title: "KK Events", message:
                "Event saved to calendar!", preferredStyle: UIAlertControllerStyle.Alert)
            self.alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: nil))
            
            
        } catch {
            self.alertController = UIAlertController(title: "Error!", message:
                "Event not saved to calendar for some reason", preferredStyle: UIAlertControllerStyle.Alert)
            self.alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: nil))
       
        }
        
        
    }



}
