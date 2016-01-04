//
//  ViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 2/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit
import Parse

extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        let secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        let secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    
    @IBOutlet weak var mainTable: UITableView!
    var eventsToday = [Event]()
    var eventsWeekend = [Event]()
    var eventsAll = [Event]()
    
    let daysOfTheWeek = ["poopday", "Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday"]
    let monthsOfTheYear = ["Monthalicious", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let daysOfTheWeekThai = ["วัน", "วันอาทิตย์", "วันจันทร์", "วันอังคาร", "วันพุธ","วันพฤหัสบดี", "วันศุกร์", "วันเสาร์"]
    let monthsOfTheYearThai = ["เดือน", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    
    // Day Selection
    var todaySelected = true
    var weekendSelected = false
    var allSelected = false
   
// Selector Buttons
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var weekendButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
 
    
    // event info to send to otherviewcontroller
    var eventInfo = "default event info"
    var eventInfoThai = ""
    var eventDescriptionImageURL = ""
    var eventDescriptionTitle = ""
    var venueLogo = ""
    var dateOfEvent = ""
    var dateOfEventThai = ""
    var entryCost = ""
    var venueName = ""
    var venueCoordinates = [0.0, 0.0]
    var eventURL = ""
    var venueURL = ""
    var venueImage = ""

    
    
   
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        
        if self.todaySelected == true{
            self.todayButton.enabled = false
        }
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        //self.getEventData()
        self.eventsToday = self.getEventData()
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func testButton(sender: AnyObject) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Selecter Button Actions
    @IBAction func todayButtonPush(sender: AnyObject) {
        self.todaySelected = true
        self.weekendSelected = false
        self.allSelected = false
        self.todayButton.enabled = false
        self.weekendButton.enabled = true
        self.allButton.enabled = true
        
        self.eventsToday = self.getEventData()
        self.mainTable.reloadData()
    }
    
    @IBAction func weekendButtonPush(sender: AnyObject) {
        self.todaySelected = false
        self.weekendSelected = true
        self.allSelected = false
        self.todayButton.enabled = true
        self.weekendButton.enabled = false
        self.allButton.enabled = true
        self.eventsWeekend = self.getEventData()
        self.mainTable.reloadData()
    }
    
    @IBAction func allButton(sender: AnyObject) {
        self.todaySelected = false
        self.weekendSelected = false
        self.allSelected = true
        self.todayButton.enabled = true
        self.weekendButton.enabled = true
        self.allButton.enabled = false
        self.eventsAll = self.getEventData()
        self.mainTable.reloadData()
    }


    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todaySelected == true {
            return self.eventsToday.count
        } else if weekendSelected == true{
            return self.eventsWeekend.count
        } else if allSelected == true {
            return self.eventsAll.count
        } else {
            return eventsToday.count
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var eventsToDisplay = [Event]()
        
        if self.todaySelected == true {
            eventsToDisplay = self.eventsToday
        } else if weekendSelected == true {
                eventsToDisplay = self.eventsWeekend
        } else if allSelected == true {
                eventsToDisplay = self.eventsAll
        } else {
            eventsToDisplay = self.eventsToday
        }
        
        let monthName = self.monthsOfTheYear[(eventsToDisplay[indexPath.row].eventDate[1])]
        let weekDayName = self.daysOfTheWeek[eventsToDisplay[indexPath.row].eventDay]
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("eventCell")!
        let eventName = NSMutableAttributedString(string:eventsToDisplay[indexPath.row].eventTitle + "\n")
        let attrib = [NSFontAttributeName: UIFont.systemFontOfSize(12.0)]
        let event = NSMutableAttributedString(string: "\(weekDayName), \(monthName)  \(eventsToDisplay[indexPath.row].eventDate[2])\n",  attributes: attrib)
        
        let placeString = NSMutableAttributedString(string: eventsToDisplay[indexPath.row].eventTime + " at " + eventsToDisplay[indexPath.row].eventPlaceName, attributes: attrib)
    
        cell.imageView!.image = UIImage(named: eventsToDisplay[indexPath.row].venueLogoImageUrl)
        cell.imageView!.alpha = 0.8


        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        event.appendAttributedString(eventName)
        event.appendAttributedString(placeString)
        cell.textLabel!.attributedText = event
        cell.textLabel!.backgroundColor = (UIColor(white: 1, alpha: 0))
        
        //set cell background
        
        cell.backgroundView = UIImageView(image: UIImage(named: eventsToDisplay[indexPath.row].eventImage)!)
        cell.backgroundView!.contentMode = UIViewContentMode.ScaleAspectFill
        cell.backgroundView?.alpha = 0.2
    
    
       // cell.textLabel!.text = self.eventsToday[indexPath.row].eventTitle + "\n " + "\(placeString)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("this is happening")
        var eventsToDisplay = [Event]()
        
        if self.todaySelected == true {
            eventsToDisplay = self.eventsToday
        } else if weekendSelected == true {
            eventsToDisplay = self.eventsWeekend
        } else if allSelected == true {
            eventsToDisplay = self.eventsAll
        } else {
            eventsToDisplay = self.eventsToday
        }
        let cellNumber = indexPath.row
        print("this is the cell no : \(cellNumber)")
        let description = eventsToDisplay[cellNumber].eventDescription
        let descriptionThai = eventsToDisplay[cellNumber].eventDescriptionThai
        let monthName = self.monthsOfTheYear[(eventsToDisplay[indexPath.row].eventDate[1])]
        let monthNameThai = self.monthsOfTheYearThai[(eventsToDisplay[indexPath.row].eventDate[1])]
        let weekDayName = self.daysOfTheWeek[eventsToDisplay[indexPath.row].eventDay]
        let weekDayNameThai = self.daysOfTheWeekThai[eventsToDisplay[indexPath.row].eventDay]
        let eventImageURL = eventsToDisplay[cellNumber].eventImage
        let venueImageURL = eventsToDisplay[cellNumber].venueLogoImageUrl
        let eventTitle = eventsToDisplay[cellNumber].eventTitle
        

        self.eventInfo = description
        self.eventDescriptionImageURL = eventImageURL
        self.eventDescriptionTitle = eventTitle
        self.venueLogo = venueImageURL
        self.eventInfoThai = descriptionThai
        self.dateOfEvent = "\(weekDayName), \(monthName)  \(eventsToDisplay[indexPath.row].eventDate[2])"
        self.dateOfEventThai = "\(weekDayNameThai)ที่ \(eventsToDisplay[indexPath.row].eventDate[2]) \(monthNameThai)"
        self.entryCost = eventsToDisplay[cellNumber].entryCost
        self.venueName = eventsToDisplay[cellNumber].eventPlaceName
        self.venueCoordinates = eventsToDisplay[cellNumber].venueCoordinates
        self.eventURL = eventsToDisplay[cellNumber].eventURL
        self.venueURL = eventsToDisplay[cellNumber].venueURL
        self.venueImage = eventsToDisplay[cellNumber].venueImage
        
       print(self.eventInfo)
        performSegueWithIdentifier("ShowEventInfoSegue", sender: self)
    }
    
    
    
    func getLocalJsonFile(fileName:String) -> [NSDictionary]{
        let appBundlePath:String? = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        
        if let actualBundalPath = appBundlePath {
            let urlPath:NSURL = NSURL(fileURLWithPath: actualBundalPath)
            let jsonData:NSData? = NSData(contentsOfURL: urlPath)
            print("getting the jsonfile: \(fileName)")
            if let actualJsonData = jsonData {
                do {
                    let arrayOfDictionaries: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                    return arrayOfDictionaries
                }
                catch{
                   
                }
            } else {
               
                
            }
        }
        else {
            
        }
        return [NSDictionary]()
    }
    
    func getEventData() -> [Event] {
        
        var eventsTodayArray:[Event] = [Event]()
        var eventsWeekendArray: [Event] = [Event]()
        var eventsAllArray: [Event] = [Event]()
        
        
        let jsonObjects:[NSDictionary] = self.getLocalJsonFile("eventz")
        
        
         var index:Int
        
        //calendar stuff
        let date = NSDate()
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday], fromDate: date)
        let day = components.day
        let year = components.year
        let month = components.month
       
        

          for index = 0; index < jsonObjects.count; index++ {
            let jsonDictionary:NSDictionary = jsonObjects[index]
            let eventVenueInfo = jsonDictionary["eventVenue"] as! String
            let venueJsonFile:[NSDictionary] = self.getLocalJsonFile(eventVenueInfo)
            let venueJson:NSDictionary = venueJsonFile[0]
            let e:Event = Event()
            
            e.eventPlaceName = venueJson["venueName"] as! String
            e.venueLogoImageUrl = venueJson["venueLogoImageUrl"] as! String
            e.phoneNumber = venueJson["venuePhoneNumber"] as! String
            e.venueCoordinates = venueJson["venueCoordinates"] as! [Double]
            e.venueImage = venueJson["venueImage"] as! String
            
            e.eventTitle = jsonDictionary["eventTitle"] as! String
            e.eventTime = jsonDictionary["eventTime"] as! String
            
            e.eventDate = jsonDictionary["eventDate"] as! [Int]
            e.eventDescription = jsonDictionary["eventDescription"] as! String
            e.eventDescriptionThai = jsonDictionary["eventDescriptionThai"] as! String
            e.eventImage = jsonDictionary["eventImage"] as! String
            e.entryCost = jsonDictionary["entryCost"] as! String
            
            
            let testURLFB = jsonDictionary["eventURL"] as! String
            if testURLFB != "" {
                e.eventURL = testURLFB
            } else {
                e.eventURL = venueJson["venueURLFB"] as! String
            }
            
            let testURL = venueJson["venueURL"] as! String
            if testURL != "" {
                e.venueURL = testURLFB
            } else {
                e.venueURL = venueJson["venueURLFB"] as! String
            }

            
            
            
            let eventFullDate = NSDate(dateString: "\(e.eventDate[0])"+"-"+"\(e.eventDate[1])"+"-"+"\(e.eventDate[2])")
            let componentsEvent = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday], fromDate: eventFullDate)
            
            e.eventDay = componentsEvent.weekday
        
            
            let compareDate = eventFullDate.addDays(-7)
            let dateAdjustedForTime = eventFullDate.addHours(30)
            
            if dateAdjustedForTime.isLessThanDate(date){
                print("this is in the past")
            } else {
                if e.eventDate[0] == year {
                    if e.eventDate[1] == month {
                        if e.eventDate[2] == day {
                            eventsTodayArray.append(e)
                    }
                }
               
            }
            
            if e.eventDay > 5 {
                if compareDate.isLessThanDate(date) == true {
                    eventsWeekendArray.append(e)
                    
                    
                }
                }
                if e.eventDay == 1 {
                if compareDate.isLessThanDate(date) == true{
                    eventsWeekendArray.append(e)
                    
                }else {
                   
                    }
              
                    

            }
          
            eventsAllArray.append(e)
            }
        
        
    }
        if self.todaySelected == true {
            return eventsTodayArray
        } else if weekendSelected == true {
            return eventsWeekendArray
        } else if allSelected == true {
            return eventsAllArray
        } else {
            return eventsTodayArray
        }

        
        
        //print(eventsTodayArray.count)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEventInfoSegue"
        {
            if let destinationVC = segue.destinationViewController as? OtherViewController{
                destinationVC.eventDeets = self.eventInfo
                destinationVC.eventImageURL = self.eventDescriptionImageURL
                destinationVC.eventTitle = self.eventDescriptionTitle
                destinationVC.logo = self.venueLogo
                destinationVC.eventDeetsThai = self.eventInfoThai
                destinationVC.eventDateThai = self.dateOfEventThai
                destinationVC.eventDate = self.dateOfEvent
                destinationVC.entryNumber = self.entryCost
                destinationVC.venueName = self.venueName
                destinationVC.venueCoordinates = self.venueCoordinates
                destinationVC.eventURL = self.eventURL
                destinationVC.venueURL = self.venueURL
                destinationVC.venueImage = self.venueImage
                
            }
                     
        }
        
    }

}


