//
//  ViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 2/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    @IBOutlet weak var mainTable: UITableView!
    var eventsToday = [Event]()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        
        
        
       
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        //self.getEventData()
        self.eventsToday = self.getEventData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsToday.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("eventCell")!
        let event = NSMutableAttributedString(string:self.eventsToday[indexPath.row].eventTitle + "\n")
        let attrib = [NSFontAttributeName: UIFont.systemFontOfSize(8.0)]
        let placeString = NSMutableAttributedString(string:self.eventsToday[indexPath.row].eventPlaceName, attributes: attrib)
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        event.appendAttributedString(placeString)
        cell.textLabel!.attributedText = event
    
       // cell.textLabel!.text = self.eventsToday[indexPath.row].eventTitle + "\n " + "\(placeString)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //user selected the cell
    }
    
    
    
    func getLocalJsonFile() -> [NSDictionary]{
        let appBundlePath:String? = NSBundle.mainBundle().pathForResource("eventz", ofType: "json")
        
        if let actualBundalPath = appBundlePath {
            let urlPath:NSURL = NSURL(fileURLWithPath: actualBundalPath)
            let jsonData:NSData? = NSData(contentsOfURL: urlPath)
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
        
        
        let jsonObjects:[NSDictionary] = self.getLocalJsonFile()
       let testCount = jsonObjects.count
        print(testCount)
        
         var index:Int
          for index = 0; index < jsonObjects.count; index++ {
        
            let jsonDictionary:NSDictionary = jsonObjects[index]
            let e:Event = Event()
            e.eventTitle = jsonDictionary["eventTitle"] as! String
            e.eventTime = jsonDictionary["eventTime"] as! String
           e.eventPlaceName = jsonDictionary["eventPlaceName"] as! String
           e.eventDay = jsonDictionary["eventDay"] as! String
            e.eventDate = jsonDictionary["eventDate"] as! [Int]
           e.venueLogoImageUrl = jsonDictionary["venueLogoImageUrl"] as! String
        eventsTodayArray.append(e)
            print("Added")
           
            
        
        
        
        
    }
        return eventsTodayArray
        //print(eventsTodayArray.count)
    }




}

