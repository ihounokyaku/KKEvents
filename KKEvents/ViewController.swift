

//
//  ViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 2/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CloudKit

class ViewController: MainViewController, UITableViewDataSource, UITableViewDelegate   {
    
//***** UI Outlets *****
    //table
    @IBOutlet weak var mainTable: UITableView!
    
    //top buttons
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    //other Labels
    @IBOutlet weak var noEventsLabel: UILabel!
    @IBOutlet weak var topMenu: UIImageView!

    // Selector Buttons and Labels
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var weekendButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var tonightText: UILabel!
    @IBOutlet weak var weekendText: UILabel!
    @IBOutlet weak var allText: UILabel!

    
//***** state variables *****
    var lastUpdated = 0
    var selectedDay = 0
    var loadNumber = 0
    var loadedOnce = false
    var success = true
    var messageState = 1
    
//***** Labels ******
    var labelArray = [UILabel]()
    let labelsByLanguage = ["Eng":["TONIGHT", "WEEKEND", "ALL", "See All Venues", "Loading"], "Thai":["คืนนี้", "เสาร์อาทิตย์นี้", "ทั้งหมด","รายละเอียดร้าน", "กำลังโหลด"]]
    let tutorial1 = ["Eng":"Thank you for downloading Khon Kaen Nightlife! Assuming you have connectivity, the nightlife-y data is now downloading (as this is the first time, it may take a little longer than usual).","Thai":"กรุณารอสักครู่ ระบบกำลังดาวน์โหลดข้อมูล ในการดาวน์โหลดข้อมูลครั้งแรก จะใช้เวลามากกว่าครั้งอื่นๆ\n\nFor English, press the little flag below - you know which one."]
    
    let tutorial2 = ["Eng":"After everything has been loaded down, you will be able to see all of the upcoming events on this front page. Click on each event to see the details. You can filter the results to show events for tonight, this weekend, and for the forseeable future by pressing the corresponding buttons above.", "Thai":"หลังจากที่ดาวน์โหลดเสร็จ กดข้างบนเพื่อเช็คกิจกรรมอีเวนท์ที่จะเกิดในคืนนี้ เสาร์อาทิตย์นี้ และอีเวนท์ทั้งหมด"]
    
    let tutorial3 = ["Eng":"You can also see special promotions just for users of this app by pressing the double-arrow thingy above.", "Thai":"สำหรับผู้ที่ใช้แอพพลิเคชั่นนี้ สามารถตรวจสอบโปรโมชั่นพิเศษได้ เลื่อนสไลด์ข้างบน"]
    
    let tutorial4 = ["Eng":"By pressing the \"See All Venues\" button below, you can see a list of bars and event venues along with the relevant information for each. You can also get a map that shows all of the places closest to you!", "Thai": "เช็คข้อมูลร้านที่ใกล้ที่สุดจากตำแหน่งที่คุณอยู่ปัจจุบัน และเช็คร้านต่างๆ ในจังหวัดขอนแก่นได้ กดรายละเอียดร้านข้างล่าง"]
    
    let tutorial5 = ["Eng":"Events, promotions, and venues are frequently added and updated, so be sure to check the app regularly!", "Thai":"มีอีเวนท์โปรโมชั่นต่างๆ เพิ่มขึ้นอัพเดทตลอดติดตามได้เรื่อยๆนะจ๊ะ"]
    
    let tutorial6 = ["Eng":"Last thing - if you like this app, please consider rating it on the iTunes store. Not only does it help spread the word about this app, everytime it happens I get a little dopamine rush and it feels niiiiiice.\n\nEnough of this. Let's get started!", "Thai":"ถ้าชอบ แอพลิเคชั่นนี้ ช่วย เรทให้เราด้วยนะจ๊ะ เพื่อพัฒนาแอพต่อๆไป ขอบคุณเด้อ!!"]
    
//***** tools *****
    //UI Tools
    var refreshControl: UIRefreshControl!
    
    //datestuff
    let date = Date()
    let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year, .weekday]

    //segueStuff
    var eventToMove:NSManagedObject!
    
    //Databases
    let database:CKDatabase = CKContainer.default().publicCloudDatabase
    
    

//**********************    Functions   *************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //***** Setup Prefs *****
        
        //language
        self.setLanguage()
        
        //get user preferences
        if let temp = UserDefaults.standard.object(forKey: "Opened") as? Bool {
            self.loadedOnce = temp
        }
        if let temp = UserDefaults.standard.object(forKey:"lastUpdated") as? Int {
            self.lastUpdated = temp
        }
        
        //toggle selected
        self.selectButton()
        
        
      //*****Table Setup*****
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        //Refresh Control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: labelsByLanguage[self.navDelegate.prefs.language]![4])
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        self.mainTable.addSubview(refreshControl)
        
        //Adjust Display and Reload
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.mainTable.contentInset = insets
        self.mainTable.reloadData()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //**** Initial Setup ****
        if loadedOnce == false {
            //Table Load
            self.mainTable.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.frame.size.height - self.topLayoutGuide.length), animated: true)
            self.refreshControl.beginRefreshing()
        }
        
        
      //**** Reload ****
        self.refreshData()
    }
   

//******* CLOUD SYNC ************
    
    func refreshData(){
        let checkConnection = Reachability()
        if  checkConnection!.connection == .none {
            self.showNoInternetMessage("ERROR'D")
            self.refreshControl.endRefreshing()
        } else {
            print("there is a network connection that connection is \(checkConnection!.connection)")
            self.startCloudSync()
        }
    }
    
    
    func removeOldObjects () {
        var objectsToRemove = [NSManagedObject]()
        let date = NSDate()
        
        let events = self.navDelegate.coreData.fetchCoreData("Event", withPredicate: NSPredicate(format: "endDate < %@", date) , withSortDescriptor: nil)
        let promotions = self.navDelegate.coreData.fetchCoreData("Promotion", withPredicate: NSPredicate(format: "endDate < %@", date) , withSortDescriptor: nil)
        
        objectsToRemove.append(contentsOf:events)
        objectsToRemove.append(contentsOf:promotions)
        
        for event in events {
            if let temp = event.value(forKey: "imageName") as? String {
                self.navDelegate.imageHandler.removeImageData(temp)
            }
        }
        for object in objectsToRemove {
            self.navDelegate.coreData.context.delete(object)
        }
        
        do {
            try self.navDelegate.coreData.context.save()
        } catch {
            print("could not save core data")
        }
    }
  
    
    func startCloudSync () {
        print("starting sync")
        let date = NSDate()
        var predicate = NSPredicate(format: "lastUpdated > %i", self.lastUpdated)
        self.getNewDataFromCloud(recordType: "Venues", predicate: predicate) {(records, dataExists) -> Void in
            if dataExists {
                DispatchQueue.main.sync {
                    self.recordsToObjects(records!, fields: self.navDelegate.coreData.venueFields, imageFields: self.navDelegate.coreData.venueImages)
                }
            }
            predicate = NSPredicate(format: "(lastUpdated > %i) && (endDate > %@)",self.lastUpdated, date)
            self.getNewDataFromCloud(recordType: "Events", predicate: predicate) {(records, dataExists) -> Void in
                if dataExists {
                    DispatchQueue.main.sync {
                        self.recordsToObjects(records!, fields: self.navDelegate.coreData.eventFields, imageFields: self.navDelegate.coreData.eventImages)
                    }
                }
                self.getNewDataFromCloud(recordType: "Promotions", predicate: predicate) {(records, dataExists) -> Void in
                    if dataExists {
                        DispatchQueue.main.sync {
                            self.recordsToObjects(records!, fields: self.navDelegate.coreData.promotionFields, imageFields: nil)
                        }
                    }
                    self.removeDeletedEntries {
                        DispatchQueue.main.sync {
                            let dateNow = Date()
                            self.lastUpdated = Int(dateNow.timeIntervalSince1970)
                            self.finishSync()
                        }
                    }
                }
            }
        }
    }
    
    
    func getNewDataFromCloud (recordType:String, predicate: NSPredicate, completion: @escaping (_ records:[CKRecord]?,_ results:Bool)-> ()) {
        print("getting cloud data for " + recordType)
   
        let query = CKQuery(recordType: recordType, predicate: predicate)
        self.database.perform(query, inZoneWith: nil){(results, error) -> Void in
            if error != nil {
                print("there was an error getting cloud data")
                //self.showError(error as NSError?, id:"remove eventIDNumber")
                print(error!)
                self.success = false
                completion(nil, false)
            } else {
                if results!.count != 0 {
                    print("there were \(results!.count) results")
                    completion(results!, true)
                } else {
                    print("there were no results")
                    completion(nil, false)
                }
            }
        }
    }
    
     func removeDeletedEntries (completion: @escaping ()->()) {
        let entities = ["Venues":self.navDelegate.coreData.venues, "Events":self.navDelegate.coreData.events, "Promotions":self.navDelegate.coreData.promotions]
        for (recordKey, objects) in entities {
            for object in objects {
                let id = object.stringValue("id")
                let predicate = NSPredicate(format: "id == %@", id)
                let query = self.cloudDataQuery(recordKey, withPredicate: predicate, withDesiredKeys: ["id"], withResultsLimit: 1)
                self.database.perform(query, inZoneWith: nil){(results, error) -> Void in
                    if error != nil {
                        print(error!)
                    } else {
                        if results!.count == 0 {
                            self.navDelegate.coreData.context.delete(object)
                        }
                    }
            }
        }
    }
        do {
            try self.navDelegate.coreData.context.save()
        } catch {
            print("error saving core Data")
        }
        completion()
    }

    
    func finishSync () {
            print("finishing sync")
            UserDefaults.standard.setValue(self.lastUpdated, forKey: "lastUpdated")
            self.refreshControl.endRefreshing()
            self.navDelegate.coreData.refresh()
            self.mainTable.reloadData()
    }
    
    

    func recordsToObjects(_ records:[CKRecord], fields:[String], imageFields:[String]?) {
        //get or create object
        
        for record in records {
            let entityName = record.value(forKey: "entityName") as! String
            var object:NSManagedObject!
            let objectID = record.value(forKey: "id") as! String
            
            
            //check if object exists in the database and create if necessary
            if self.navDelegate.coreData.objectWithID(objectID, ofType: entityName) != nil {
                object = self.navDelegate.coreData.objectWithID(objectID, ofType: entityName)
                
            } else {
                
                //object not in the database -> create new object
                let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.navDelegate.coreData.context)
                object = NSManagedObject(entity: entity!, insertInto: self.navDelegate.coreData.context)
            }
            
            //fill in the main fields
            for field in fields {
                object.setValue(record.value(forKey: field), forKey: field)
            }
            
            //attach a venue if necessary
            if entityName != "Venue" {
                if let venueID = record.value(forKey: "venue") as? String {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Venue")
                    fetchRequest.predicate = NSPredicate(format: "id == %@", venueID)
                    do {
                        let coreDataResults = try self.navDelegate.coreData.context.fetch(fetchRequest)
                        if coreDataResults.count > 0 {
                            object.setValue(coreDataResults[0], forKey: "venue")
                        } else {
                            print("could not find venue in core data")
                        }
                    } catch {
                        print("could not fetch venue")
                    }
                }
            }
            
            //get image if necessary
            if imageFields != nil {
                for imageField in imageFields! {
                    let imageNameField = imageField + "Name"
                    let imageName = object.value(forKey: imageNameField) as! String
                    
                    if !self.navDelegate.imageHandler.imageExists(imageName) {
                        if let imageAsset = record.value(forKey: imageField) as? CKAsset {
                            //write to folder
                            self.navDelegate.imageHandler.saveImage(imageAsset, imageName: imageName)
                        } else {
                            print("no image in cloud")
                        }
                    }
                }
                do {
                    try self.navDelegate.coreData.context.save()
                } catch let error as NSError {
                    print("could not save \(error), \(error .userInfo)")
                }
            }
        }
    }
    
    
    
    func cloudDataQuery(_ ofType:String, withPredicate:NSPredicate, withDesiredKeys:[String]?, withResultsLimit: Int?)-> CKQuery {
        let query = CKQuery(recordType: ofType, predicate: withPredicate)
        let operation = CKQueryOperation(query:query)
        operation.desiredKeys = withDesiredKeys
        if withResultsLimit != nil {
            operation.resultsLimit = withResultsLimit!
        }
        return query
    }
    
    
    func showError (_ error:NSError?, place:String) {
        print("THIS IS YOUR ERROR! \(String(describing: error)) this happened at step" + place)
    }
    
    
    
    
//*****  TABLEVIEW STUFF **********
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.navDelegate.coreData.eventArrays[self.selectedDay].count == 0 {
            //self.showNoEventsMessage()
            //self.noEventsLabel.isHidden = false
        } else {
            self.noEventsLabel.text = ""
            self.noEventsLabel.isHidden = true
        }
        return self.navDelegate.coreData.eventArrays[self.selectedDay].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        let eventsToDisplay = self.navDelegate.coreData.eventArrays[self.selectedDay]
        
        let event = eventsToDisplay[indexPath.row]
        var dateString = "Someday"
        var titleString = "Something"
        var timeString = "18:00"
        var at = ["Eng":" at ", "Thai":" ที่"]
        var logo = UIImage(named: "noImage.png")

        let keys = ["Eng":["title", "name"], "Thai":["titleThai", "nameThai"]]
        if let date = event.value(forKey: "date") as? Date {
            dateString = date.string(self.navDelegate.prefs.language, dateFormat: ["Thai":"EEEE ที่ d MMM", "Eng":"EEEE, MMMM d"])
            timeString = date.string(self.navDelegate.prefs.language, dateFormat: ["Thai":"HH:mm", "Eng":"HH:mm"])
        }
        
        var placeString = timeString + at[self.navDelegate.prefs.language]!
        
        if let temp = event.value(forKey: keys[self.navDelegate.prefs.language]![0]) as? String {
            titleString = temp
        }
        
      //*** Set Image ****
        if let temp = event.value(forKey: "venue") as? NSManagedObject {
            if let temp2 = temp.value(forKey: keys[self.navDelegate.prefs.language]![1]) as? String {
                placeString += temp2
            }
            if let temp3 = temp.value(forKey: "logoName") as? String {
                logo = self.navDelegate.imageHandler.getImageData(temp3)
            }
        }
        cell.logoPic.image = logo
        cell.logoPic.alpha = 0.8
        
      //**** Set Cell BKG and Text ***
        var color = "ffffff"
        if indexPath.row % 2 != 0 {
            color = "eeeeee"
        }
        cell.backgroundColor = color.UIColorFromRGB()
        cell.dateLabel.text = dateString
        cell.titleLabel.text = titleString
       
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var eventsToDisplay = [NSManagedObject]()
        
        eventsToDisplay = self.navDelegate.coreData.eventArrays[selectedDay]
        
        
        self.eventToMove = eventsToDisplay[indexPath.row]

        performSegue(withIdentifier: "ShowEventInfoSegue", sender: self)
        
    }
    
    
    
    
    
//**** Selecter Button Actions ****
    @IBAction func todayButtonPush(_ sender: AnyObject) {
        self.selectedDay = 1
        self.selectButton()
    }
    
    @IBAction func weekendButtonPush(_ sender: AnyObject) {
        self.selectedDay = 2
        self.selectButton()
    }
    
    @IBAction func allButton(_ sender: AnyObject) {
        print("allButton pressed")
        self.selectedDay = 0
        self.selectButton()
    }
    
    func selectButton () {
        var buttons = [self.allButton, self.todayButton, self.weekendButton]
       
        buttons[self.selectedDay]!.isEnabled = false
        buttons.remove(at: self.selectedDay)
        for button in buttons {
            button!.isEnabled = true
        }
        
        UIView.transition(with: self.topMenu, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.topMenu.image = UIImage(named: "menu\(self.selectedDay + 1).png")
            
       }, completion: nil)
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.fillMode = kCAFillModeForwards
        transition.duration = 0.3
        transition.subtype = kCATransitionFromTop
        self.mainTable.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        self.mainTable.reloadData()
    }
    
    
//**** LANGUAGE STUFF ******
    @IBAction func englishButtonPressed(_ sender: AnyObject) {
        self.englishText()
    }
    @IBAction func thaiButtonPressed(_ sender: AnyObject) {
        self.thaiText()
    }
    func thaiText () {
        self.navDelegate.prefs.thaiOn = true
        self.navDelegate.prefs.set()
        self.setLanguage()
        
    }
    func englishText () {
        self.navDelegate.prefs.thaiOn = false
        self.navDelegate.prefs.set()
        self.setLanguage()
    }
    
    func setLanguage() {
        
        self.thaiButton.isEnabled = !self.navDelegate.prefs.thaiOn
        self.englishButton.isEnabled = self.navDelegate.prefs.thaiOn
        
        self.labelArray = [self.tonightText, self.weekendText, self.allText]
        for label in self.labelArray {
            let index = self.labelArray.index(of: label)!
            label.text = self.labelsByLanguage[self.navDelegate.prefs.language]![index]
        }
        self.mainTable.reloadData()
    }
    
//*** OTHER BUTTONS ****
    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/groups/445555728870201/")!)
    }
    
    
    
//***** ERROR/EVENT MESSAGES *******
    
    func showNoInternetMessage(_ message:String) {
        
        let alert = UIAlertController(title: message, message: "Could not find any internets\nThe information you see may not be up to date.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okee Dokee", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoEventsMessage() {
        let noEventsMessages = ["Eng":["It appears there are no special events going on...ever. \n\nHmmmm. That's strange. You may want to check your internet connection or hit the refresh arrow above and attempt to reload the data. \n\nIf it turns out that there really are no events scheduled right now, that won't be the case for long, so be sure to check back soon!","Looks like there are no special events going on tonight, but there are still plenty of great places to go have a cold one - or whatever kind of one you prefer to have!\n\nPress the \"See All Venues\" button below to find out what's near you!\nYou can also press the \"This Weekend\" and \"All\" buttons above to see what events are coming up in the future.","Looks like there are no special events going on this weekend, but there are still plenty of great places to go have a cold one - or whatever kind of one you prefer to have!\n\nPress the \"See All Venues\" button below to find out what's near you!\nYou can also press the \"Tonight\" and \"All\" buttons above to see what events are going on this evening or coming up in the future."], "Thai":["ไม่มีข้อมูลอีเวนท์ กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต แล้วกดลูกศรข้างบนเพื่อโหลดข้อมูลใหม่อีกครั้ง","คืนนี้ไม่มีอีเวนท์พิเศษ\n\nแต่มีร้านต่างๆในขอนแก่นที่น่าสนใจ เช็ครายละเอียดร้านต่างๆได้ กดข้างล่าง \n\nหรือกดข้างบนเพื่อเช็คอีเวนท์ที่จะมีในเสาร์อาทิตย์นี้ และอีเวนท์ที่จะเกิดขึ้นทั้งหมด","เสาร์อาทิตย์นี้ไม่มีอีเวนท์พิเศษ\n\nแต่มีร้านต่างๆในขอนแก่นที่น่าสนใจ เช็ครายละเอียดร้านต่างๆได้ กดข้างล่าง\n\nหรือกดข้างบนเพื่อเช็คอีเวนท์ที่จะมีในคืนนี้ และอีเวนท์ที่จะเกิดขึ้นทั้งหมด"]]
        
        self.noEventsLabel.text = noEventsMessages[self.navDelegate.prefs.language]![self.selectedDay]
    }


//*** Navigation Stuff ****
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        self.navDelegate.prefs.refresh()
        self.setLanguage()
        self.mainTable.reloadData()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventInfoSegue"
        {
            if let destinationVC = segue.destination as? OtherViewController{
                destinationVC.event = self.eventToMove
            }
        }
    }
}


