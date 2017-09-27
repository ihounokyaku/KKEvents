//
//  CoreData.swift
//  KKNLoader
//
//  Created by Dylan Southard on 2017/06/29.
//  Copyright © 2017 Dylan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreData: NSObject {
    
    var events = [NSManagedObject]()
    var venues = [NSManagedObject]()
    var promotions = [NSManagedObject]()
    
    var eventsToday = [NSManagedObject]()
    var eventsThisWeekend = [NSManagedObject]()
    
    var eventArrays = [[NSManagedObject]]()
    
    var venueIDs = [String]()
    var eventIDs = [String]()
    var promotionIDs = [String]()
    
    var promotionsByVenue = [String:[NSManagedObject]]()
    var promotionVenues = [String]()
    
    let venueFields = ["bkgImageName", "coordinates1", "coordinates2", "desc", "descThai", "id", "logoName", "name", "nameThai", "password", "phoneNumber", "type", "url", "urlFB", "venueList"]
    let venueImages = ["bkgImage", "logo"]

    let eventFields = ["reoccurring", "cost", "date", "desc", "descThai", "endDate", "id", "imageName", "otherVenue", "otherVenueCoordinates1", "otherVenueCoordinates2", "otherVenueName", "otherVenueNameThai", "title", "titleThai", "url"]
    let eventImages = ["image"]
    
     let promotionFields = ["date", "desc", "descThai", "endDate", "id", "subtitle", "subtitleThai", "title", "titleThai"]
    
    let venueNameKeys = ["Eng":"name", "Thai":"nameThai"]

    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    override init () {
        super.init()
        self.refresh()
    }
    
    
    func refresh () {
        let todaysDate = NSDate()
        let dateSearch = NSPredicate (format: "endDate > %@", todaysDate)
        let eventFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        let promotionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Promotion")
        eventFetchRequest.predicate = dateSearch
        promotionFetchRequest.predicate = dateSearch
        
        
        
        (self.venues, self.venueIDs) = self.fetchCoreDataAndIDs("Venue", withPredicate: NSPredicate(format: "venueList == %i", 1), withSortDescriptor: NSSortDescriptor(key: "name", ascending: true))
        (self.events, self.eventIDs) = self.fetchCoreDataAndIDs("Event", withPredicate: NSPredicate (format: "endDate > %@", todaysDate), withSortDescriptor: NSSortDescriptor(key: "date", ascending: true))
        (self.promotions, self.promotionIDs) = self.fetchCoreDataAndIDs("Promotion", withPredicate: NSPredicate (format: "endDate > %@", todaysDate), withSortDescriptor: nil)
        
        //get today's events
        self.eventsToday.removeAll()
        self.eventsThisWeekend.removeAll()
        
        for event in self.events {
            if let startDate = event.value(forKey: "date") as? Date {
                if let endDate = event.value(forKey: "endDate") as? Date {
                    let date = Date()
                    if startDate.isToday() || (startDate < date && endDate > date) {
                        self.eventsToday.append(event)
                    }
                }
            }
        }
        
        //get the weekend's events
        for event in self.events {
            if let date = event.value(forKey: "date") as? Date {
                if date.isThisWeekend() {
                    self.eventsThisWeekend.append(event)
                }
            }
        }
        
        
        //sort promotions
        self.promotionsByVenue = [:]
        self.promotionVenues.removeAll()
        for promotion in self.promotions {
            if let venue = promotion.value(forKey: "venue") as? NSManagedObject {
                if let venueID = venue.value(forKey: "id") as? String {
                    if self.promotionsByVenue[venueID] == nil {
                        self.promotionsByVenue[venueID] = [promotion]
                        self.promotionVenues.append(venueID)
                    } else {
                        self.promotionsByVenue[venueID]!.append(promotion)
                    }
                }
            }
        }
        
        self.eventArrays = [self.events, self.eventsToday, self.eventsThisWeekend]
        
        
            
            }
    
    
    
    func fetchCoreData(_ withEntityName:String, withPredicate:NSPredicate, withSortDescriptor:NSSortDescriptor?)-> [NSManagedObject] {
        var objectsToReturn : [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName)
        if let temp = withSortDescriptor {
            fetchRequest.sortDescriptors = [temp]
        }
        fetchRequest.predicate = withPredicate
        do {
            let objectsToAdd = try self.context.fetch(fetchRequest)
            
            for objectToAdd in objectsToAdd as! [NSManagedObject]{
                
                
                   
                        objectsToReturn.append(objectToAdd)
                    
                
            }
        }
        catch {
            print("fetching objectFromCoreData failed")
        }
        
        return objectsToReturn
    }
    
    func fetchCoreDataAndIDs(_ withEntityName:String, withPredicate:NSPredicate, withSortDescriptor:NSSortDescriptor?)-> ([NSManagedObject], [String]) {
        var objectsToReturn : [NSManagedObject] = []
        var objectIDs = [String]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName)
        if let temp = withSortDescriptor {
            fetchRequest.sortDescriptors = [temp]
        }
        fetchRequest.predicate = withPredicate
        do {
            let objectsToAdd = try self.context.fetch(fetchRequest)
            
            for objectToAdd in objectsToAdd as! [NSManagedObject]{
                
                if let temp = objectToAdd.value(forKey: "id") as? String {
                    if !objectIDs.contains(temp) {
                        objectIDs.append(temp)
                        objectsToReturn.append(objectToAdd)
                    } else {
                        self.context.delete(objectToAdd)
                        try self.context.save()
                    }
                }
            }
        }
        catch {
            print("fetching objectFromCoreData failed")
        }
        
        return (objectsToReturn, objectIDs)
    }
    
    func stringValues(_ forKey:String, ofRelation:String?, inObjects:[NSManagedObject]) -> [String] {
        var valueArray = [String]()
        var objects = inObjects
        if ofRelation != nil {
            objects.removeAll()
            for object in inObjects {
                if let relation = object.value(forKey: ofRelation!) as? NSManagedObject {
                    objects.append(relation)
                }
            }
        }
        
        for object in objects {
            if let value = object.value(forKey: forKey) as? String {
                valueArray.append(value)
            }
        }
        return valueArray
    }
    
    func objectWithID(_ objectID:String, ofType:String)-> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:ofType)
        fetchRequest.predicate = NSPredicate(format: "id == %@", objectID)
        do {
            let coreDataResults = try self.context.fetch(fetchRequest) as! [NSManagedObject]
            if coreDataResults.count > 0 {
                return coreDataResults[0]
            } else {
                print("could not find object in core data")
                return nil
                
            }
        } catch {
            print("could not fetch object")
        }
        return nil
    }
}
