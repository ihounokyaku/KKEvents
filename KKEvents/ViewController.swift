
//
//  ViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 2/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit
import Foundation


extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
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

extension String  {
    func truncateTail (maxCharacters:Int)->String {
        var stringy = self
        let difference = stringy.characters.count - maxCharacters
        var index = 0
        if difference > 0 {
            for index = 0; index <= difference; index++ {
           stringy.removeAtIndex(stringy.endIndex.predecessor())
            }
            let
            stringy = stringy+"…"
            return stringy
        } else {
        return self
        }
    }
}
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    
    @IBOutlet weak var couponTable: UITableView!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var upcomingEventsLabel: UILabel!
    
    @IBOutlet weak var couponDeelyo: CouponView!
    var coupons:CouponView!
    
    var eventsToday = [Event]()
    var eventsWeekend = [Event]()
    var eventsAll = [Event]()
    
    var couponsToDisplay = [Coupon]()
    
    let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
    
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
    @IBOutlet weak var syncImage: UIImageView!
 
    let selectedButtonFont:UIFont! =  UIFont(name: "HelveticaNeue-Medium", size: 22)
    let unselectedButtonFont:UIFont! =  UIFont(name: "HelveticaNeue-Thin", size: 22)
    
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
    var venuePhone = ""
    var eventDateFull = NSDate()
    var eventTitleThai = ""
    
    // coupon info to send to couponview
    var couponVenue = ""
    var couponTitle = ""
    var couponTitleThai = ""
    var couponDate = [Int]()
    var couponEndDate = [Int]()
    var couponDescription = ""
    var couponDescriptionThai = ""
    var couponImage = ""
    var couponLogo = ""
    var couponPhoneNumber = ""
    var couponMap = [Double]()
    var couponEndDay:Int = 0
    var daysLeftToExpiration = 0
    var couponSubtitle = ""
    var couponSubtitleThai = ""
    

//    var gotJson:Bool = false
    var gotUrlJson:Bool = false
    var gotEventJson:Bool = false
    
    var loadedOnce = false
    
   //dictionaries
    var jsonObjects = [NSDictionary]()
    var urlList = [NSDictionary]()
    var couponJson = [NSDictionary]()
    
    var couponVenues = [String]()
    var couponsUnderHeaders = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //coupons = NSBundle.mainBundle().loadNibNamed("Coupons", owner: self, options: nil).last as! CouponView
        let arrowUp:UIImage! = UIImage(named:"arrowUp.png")
        let arrowDown:UIImage! = UIImage(named:"arrowDown.png")
        
        
        self.couponDeelyo.frame = CGRectMake(0, -self.view.frame.size.height + 100, self.view.frame.size.width, self.view.frame.size.height)
        
        //self.view.addSubview(coupons)
        self.couponDeelyo.setImage(arrowUp, arrowDown:arrowDown)
        self.couponDeelyo.setup()
        //self.couponDeelyo.changeLabel("this worked")

        
        self.placeCouponView()
       
    
        
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        

        
        if self.todaySelected == true{
            self.todayButton.enabled = false
        }
        self.couponTable.delegate = self
        self.couponTable.dataSource = self
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.upcomingEventsLabel.text = "Loading Events"
        
        self.urlList = self.getLocalJsonFile("urlList.json")
        self.jsonObjects = self.getLocalJsonFile("eventz.json")
        self.couponJson = self.getLocalJsonFile("couponz.json")
        self.eventsAll = self.getEventData()
        self.eventsWeekend = self.getEventData()
        self.eventsToday = self.getEventData()
        self.couponsToDisplay = self.getCouponInfo()
        self.couponVenues = self.getNumberOfCouponHeaders()
        self.couponsUnderHeaders = self.getCouponsForEachHeader()
        self.couponTable.reloadData()
        self.mainTable.reloadData()
        
        
        
        
        
        //self.getEventData()
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBAction func testButton(sender: AnyObject) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.loadedOnce == false {
            self.syncImage.image = UIImage(named: "syncDis.png")
            //self.syncImage.startRotating()
             self.rotateView(syncImage)
            print("VDA Start")
        self.refreshData()
        }
        
        self.loadedOnce = true
        
    }
    func placeCouponView (){
            }


func ukButtenPressed (){
    print("PRESSED")
}

    func refreshData(){
        self.upcomingEventsLabel.text = "Loading Events"
        self.syncImage.image = UIImage(named: "syncDis.png")
        //self.syncImage.startRotating()
        self.rotateView(syncImage)
        print("RD Start")
        let checkConnection = Reachability()
        let networkConnection = checkConnection.isConnectedToNetwork()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if  networkConnection == true {
                self.downloadMainJsonData("https://dl.dropboxusercontent.com/u/2223187/urlList.json")
                self.urlList = self.getLocalJsonFile("urlList.json")
                self.downloadMainJsonData("https://dl.dropboxusercontent.com/u/2223187/eventz.json")
                self.jsonObjects = self.getLocalJsonFile("eventz.json")
                self.couponJson = self.getLocalJsonFile("couponz.json")
                self.downloadOtherJsonData()
                self.downloadImageData("venueImages")
                self.downloadImageData("eventImages")
                self.clearUnusedImages()
                
                self.eventsAll = self.getEventData()
                self.eventsWeekend = self.getEventData()
                self.eventsToday = self.getEventData()
                self.couponsToDisplay = self.getCouponInfo()
                self.couponVenues = self.getNumberOfCouponHeaders()
                self.couponsUnderHeaders = self.getCouponsForEachHeader()
                
                self.couponTable.reloadData()
                self.mainTable.reloadData()
                
                
                print("GOT JSON FILE")
                
            } else {
                self.upcomingEventsLabel.text = "No Internet Connection"
                self.syncImage.image = UIImage(named: "syncEn")
               // self.syncImage.stopRotating()
                 self.stopRotatingView(self.syncImage)
                print("No Internet Stop")
            }
            dispatch_async(dispatch_get_main_queue(),{
            })

            })
        
    }
    // Selecter Button Actions
    @IBAction func todayButtonPush(sender: AnyObject) {
        self.todaySelected = true
        self.weekendSelected = false
        self.allSelected = false
        self.todayButton.enabled = false
        self.weekendButton.enabled = true
        self.allButton.enabled = true
        self.placeCouponView()
        self.todayButton.titleLabel!.font =  self.selectedButtonFont
        self.weekendButton.titleLabel!.font = self.unselectedButtonFont
        self.allButton.titleLabel!.font = self.unselectedButtonFont
        self.eventsToday = self.getEventData()
        self.couponTable.reloadData()
        self.mainTable.reloadData()
    }
    
    @IBAction func weekendButtonPush(sender: AnyObject) {
        
        self.todaySelected = false
        self.weekendSelected = true
        self.allSelected = false
        self.todayButton.enabled = true
        self.weekendButton.enabled = false
        self.allButton.enabled = true
        self.placeCouponView()
        self.todayButton.titleLabel!.font =  self.unselectedButtonFont
        self.weekendButton.titleLabel!.font = self.selectedButtonFont
        self.allButton.titleLabel!.font = self.unselectedButtonFont
        
         self.eventsWeekend = self.getEventData()
        self.mainTable.reloadData()
        self.couponTable.reloadData()
    }
    
    @IBAction func allButton(sender: AnyObject) {
        self.todaySelected = false
        self.weekendSelected = false
        self.allSelected = true
        self.todayButton.enabled = true
        self.weekendButton.enabled = true
        self.allButton.enabled = false
        self.placeCouponView()
        self.todayButton.titleLabel!.font =  self.unselectedButtonFont
        self.weekendButton.titleLabel!.font = self.unselectedButtonFont
        self.allButton.titleLabel!.font = self.selectedButtonFont
        
        self.eventsAll = self.getEventData()
        self.mainTable.reloadData()
        self.couponTable.reloadData()
    }

    // refres

    @IBAction func pressRefresh(sender: AnyObject) {
        self.refreshData()
    }
    
    
    func downloadMainJsonData(url:String){
        if let jsonURL = NSURL(string: url) {
            // create your document folder url
            let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
            // your destination file url
            let destinationUrl = documentsUrl.URLByAppendingPathComponent(jsonURL.lastPathComponent!)
            print("\(destinationUrl)")
            
            
            // check if it exists before downloading it
            
            if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                print("The file \(jsonURL.lastPathComponent!)already exists at path")
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(destinationUrl.path!)
                    print("fileRemoved")
                }catch {
                    print("file not removed")
                }
            }
            
            //  if the file doesn't exist
            //  just download the data from your url
            if let jsonFileFromUrl = NSData(contentsOfURL: jsonURL){
                // after downloading your data you need to save it to your destination url
                if jsonFileFromUrl.writeToURL(destinationUrl, atomically: true) {
                    print("file saved")
                    
                    
                } else {
                    print("error saving file")
                    
                }
            }
        }
        
    }
    
    func downloadOtherJsonData(){
        var index: Int
        var downloadedArray = [String]()
        
        //for index = 0; index < self.jsonObjects.count; index++ {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let jsonPath = paths.stringByAppendingPathComponent("urlList.json")
        let jsonList:NSArray = (self.urlList[1])["venuez"]! as! NSArray
       

        if NSFileManager().fileExistsAtPath(jsonPath) {
            for index = 0; index < jsonList.count; index++ {
            
            
            let url = jsonList[index] as! String
                
          
                if let jsonURL = NSURL(string: "https://dl.dropboxusercontent.com/u/2223187/\(url)") {
            // create your document folder url
                    let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
            // your destination file url
                    let destinationUrl = documentsUrl.URLByAppendingPathComponent(jsonURL.lastPathComponent!)
                   
            
            // check if it exists before downloading it
                    if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                        print("The file already exists at path")
                        do {
                            try NSFileManager.defaultManager().removeItemAtPath(destinationUrl.path!)
                            print("fileRemoved")
                        }catch {
                            print("file not removed")
                        }
                    }
            
            //  if the file doesn't exist
            //  just download the data from your url
                    if let jsonFileFromUrl = NSData(contentsOfURL: jsonURL){
                // after downloading your data you need to save it to your destination url
                        if jsonFileFromUrl.writeToURL(destinationUrl, atomically: true) {
                            print("file saved")
                            
                            downloadedArray.append(url)
                            
                        } else {
                            print("error saving file")
                    
                }
            }
        }
            }
        } else {
            print("no Jsonfile at path")
        }
        self.couponsToDisplay = self.getCouponInfo()
        self.couponVenues = self.getNumberOfCouponHeaders()
        self.couponsUnderHeaders = self.getCouponsForEachHeader()
        self.couponTable.reloadData()
    }
    
    func downloadImageData(kind:String){
        
        var index: Int
        let imageList:NSArray = (self.urlList[2])[kind]! as! NSArray
        for index = 0; index < imageList.count; index++ {
            let imageFileName = imageList[index] as! String
            let url = "https://dl.dropboxusercontent.com/u/2223187/Images/"+imageFileName
            
            if let imageURL = NSURL(string: url) {
                // create your document folder url
                let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
                // your destination file url
                let destinationUrl = documentsUrl.URLByAppendingPathComponent(imageURL.lastPathComponent!)
                
                // check if it exists before downloading it
                if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                } else {
                  
                if let imageFileFromUrl = NSData(contentsOfURL: imageURL){
                    // after downloading your data you need to save it to your destination url
                    if imageFileFromUrl.writeToURL(destinationUrl, atomically: true) {
                        
                    } else {
                        print("error saving file")
                        
                    }
                    
                }
                    
                }
            }
        }
        self.syncImage.image = UIImage(named: "syncEn")
        //self.syncImage.stopRotating()
        self.stopRotatingView(syncImage)
        print("Download Image Stop")
        self.upcomingEventsLabel.text = "Upcoming Events"
    }
    
    func clearUnusedImages() {
        var index: Int
        let imageList:NSArray = (self.urlList[2])["trash"]! as! NSArray
        for index = 0; index < imageList.count; index++ {
            let imageFileName = imageList[index] as! String
            let url = "https://dl.dropboxusercontent.com/u/2223187/Images/"+imageFileName
            
            if let imageURL = NSURL(string: url) {
                // create your document folder url
                let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
                // your destination file url
                let destinationUrl = documentsUrl.URLByAppendingPathComponent(imageURL.lastPathComponent!)
                
                // check if it exists before downloading it
                if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                    print("The file already exists at path")
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(destinationUrl.path!)
                        print("fileRemoved")
                    }catch {
                        print("file not removed")
                    }
                }
                
            }
            
        }
        
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.mainTable {
            return 1
        }
        if tableView == self.couponTable {
            if self.couponVenues.count != 0 {
                return self.couponVenues.count
            } else {
                return 1
            }
            
        } else {
            return 1
        }
        
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnInt = 0
        if tableView == self.mainTable {
            if todaySelected == true {
                return self.eventsToday.count
            } else if weekendSelected == true{
                return self.eventsWeekend.count
            } else if allSelected == true {
                return self.eventsAll.count
            } else {
                returnInt = eventsToday.count
            }
        } else if tableView == self.couponTable{
            if self.couponVenues.count != 0 {
                let venueName = self.couponVenues[section]
                let couponsAtVenue = self.couponsUnderHeaders[venueName] as! [Coupon]
                returnInt = couponsAtVenue.count
                
            }
        }
    return returnInt
    
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.mainTable {
            return 0
        } else if tableView == self.couponTable {
            return 50
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        if tableView == mainTable {
           
        }
        
        if tableView == couponTable {
            let colorPicker = FontColorChange()
            
            header.frame = CGRectMake(0, 0, tableView.frame.width, 50)
            let headerCenterX = tableView.frame.width / 2
            let headerCenterY = header.frame.height  / 2
            let imageSize = header.frame.height - 10
            

            header.backgroundColor = colorPicker.UIColorFromRGB("294d69")
            let frame = CGRectMake(15, 0, imageSize, imageSize)
            let customView: UIImageView = UIImageView(frame: frame)
          
           
            customView.center.y = headerCenterY
            
            if self.couponVenues.count > section {
                let sectionViewName = self.couponVenues[section]
                let gimage = GetImage()
        
            let couponVenueInfo = self.couponsUnderHeaders[sectionViewName] as! [Coupon]
            let couponImageName = couponVenueInfo[0].couponLogo
            let couponImageToUse:UIImage = gimage.getImageFromDocuments(couponImageName)
            customView.image = couponImageToUse
        
            
            let attrib = [NSFontAttributeName: UIFont(name: "DBHelvethaicaX-Li", size: 35)!]
            let placeName = NSMutableAttributedString(string:sectionViewName, attributes:attrib)
            let titleEnglishLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
            titleEnglishLabel.textColor = colorPicker.UIColorFromRGB("accae1")
            //titleEnglishLabel.frame.size.width = labelWidth
            titleEnglishLabel.textAlignment = NSTextAlignment.Center
            titleEnglishLabel.adjustsFontSizeToFitWidth = true
            titleEnglishLabel.attributedText = placeName
            titleEnglishLabel.center.y = headerCenterY
            titleEnglishLabel.center.x = headerCenterX + 20
            //titleEnglishLabel.frame.origin.x = 50
            //titleEnglishLabel.frame.origin.y = 0
            titleEnglishLabel.alpha = 1
            
            
            header.addSubview(titleEnglishLabel)
            header.addSubview(customView)
            
            
        }
        }
        return header
    
    }
    
    
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if tableView == self.mainTable {
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
        
            cell = tableView.dequeueReusableCellWithIdentifier("eventCell")!
        
            var titleToAlter = ""
       
        
            let attrib = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
    
            if eventsToDisplay[indexPath.row].eventTitle != "" {
                titleToAlter = eventsToDisplay[indexPath.row].eventTitle
            
            } else {
                titleToAlter = eventsToDisplay[indexPath.row].eventTitleThai
           
        }
        
            let titleToDisplay = titleToAlter.truncateTail(19)

            let eventName = NSMutableAttributedString(string:titleToDisplay + "\n")
        
            let event = NSMutableAttributedString(string: "\(weekDayName), \(monthName)  \(eventsToDisplay[indexPath.row].eventDate[2])\n", attributes:attrib)
        
        
            let placeString = NSMutableAttributedString(string: eventsToDisplay[indexPath.row].eventTime + " at " + eventsToDisplay[indexPath.row].eventPlaceName, attributes: attrib)
        
        
            let gimage = GetImage()
            let eventImageName = eventsToDisplay[indexPath.row].eventImage
            let eventImageToUse:UIImage = gimage.getImageFromDocuments(eventImageName)
            let logoImageName = eventsToDisplay[indexPath.row].venueLogoImageUrl
            let logoImageToUse:UIImage = gimage.getImageFromDocuments(logoImageName)
        
        //set cell image
            cell.imageView!.image = logoImageToUse
            cell.imageView!.alpha = 0.8
        
        //set cell background
            cell.backgroundView = UIImageView(image: eventImageToUse)
            cell.backgroundView!.contentMode = UIViewContentMode.ScaleAspectFill
            cell.backgroundView?.alpha = 0.2
        
    
            cell.textLabel!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            cell.textLabel!.textAlignment = NSTextAlignment.Center
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            event.appendAttributedString(eventName)
            event.appendAttributedString(placeString)
            cell.textLabel!.attributedText = event
            cell.textLabel!.backgroundColor = (UIColor(white: 1, alpha: 0))
        
        }
        if tableView == self.couponTable {
            
            
            cell = tableView.dequeueReusableCellWithIdentifier("couponCell")!
            
            let venueNameForSection = self.couponVenues[indexPath.section]
            let cellsInSection = self.couponsUnderHeaders[venueNameForSection] as! [Coupon]
            let couponInCell = cellsInSection[indexPath.row]
            
            
            let attrib = [NSFontAttributeName: UIFont(name: "DBHelvethaicaX-36ThinIt", size: 33)!]
            let attrib2 = [NSFontAttributeName: UIFont(name: "DBHelvethaicaX-Li", size: 20)!]
            var titleToDisplay = ""
            let englishTitle = couponInCell.couponTitle
            let thaiTitle = couponInCell.couponTitleThai
            
            if englishTitle != "" {
                if thaiTitle != "" {
                    titleToDisplay = englishTitle + " / " + thaiTitle
                } else {
                    titleToDisplay = englishTitle
                }
            }else {
                titleToDisplay = thaiTitle
            }
            
            
            let colorPicker = FontColorChange()
            let couponName = NSMutableAttributedString(string:titleToDisplay, attributes:attrib)
            couponName.addAttribute(NSForegroundColorAttributeName, value: colorPicker.UIColorFromRGB("294d69"), range: NSMakeRange(0, couponName.length))
            var expirationString = ""
            var textColor = ""
            if couponInCell.daysLeftToExpiration > 1 {
                expirationString = "Expires in \(couponInCell.daysLeftToExpiration) days / หมดโปรภายใน \(couponInCell.daysLeftToExpiration) วัน"
                textColor = "294d69"
            } else if couponInCell.daysLeftToExpiration == 1 {
                textColor = "c83f27"
                expirationString = "EXPIRES TOMORROW! / หมดโปรพรุ่งนี้!"
            } else {
                expirationString = "EXPIRES TODAY! / หมดโปรวันนี้!"
                textColor = "c83f27"
            }
            
            let expirationDate = NSMutableAttributedString(string:"\n" + expirationString, attributes:attrib2)
            expirationDate.addAttribute(NSForegroundColorAttributeName, value: colorPicker.UIColorFromRGB(textColor), range: NSMakeRange(0, expirationDate.length))
            
            couponName.appendAttributedString(expirationDate)
            
            cell.textLabel!.attributedText = couponName
            cell.textLabel!.textAlignment = NSTextAlignment.Center
            cell.textLabel!.adjustsFontSizeToFitWidth = true
            
            cell.textLabel!.numberOfLines = 0
            

            
            
           // let gimage = GetImage()
            //let couponImageName = couponInCell.couponLogo
            //let couponImageToUse:UIImage = gimage.getImageFromDocuments(couponImageName)
            
            //cell.imageView!.image = couponImageToUse
            
           
        }
        
    
    
       // cell.textLabel!.text = self.eventsToday[indexPath.row].eventTitle + "\n " + "\(placeString)"
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.mainTable {
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
        self.venuePhone = eventsToDisplay[cellNumber].phoneNumber
        self.eventDateFull = eventsToDisplay[cellNumber].eventDateFull
        self.eventTitleThai = eventsToDisplay[cellNumber].eventTitleThai
        
        
       
        performSegueWithIdentifier("ShowEventInfoSegue", sender: self)
        }
        
        if tableView == couponTable {
            
            let venueNameForSection = self.couponVenues[indexPath.section]
            let cellsInSection = self.couponsUnderHeaders[venueNameForSection] as! [Coupon]
            let couponInCell = cellsInSection[indexPath.row]
            
            self.couponVenue = couponInCell.couponVenue
            self.couponTitle = couponInCell.couponTitle
            self.couponTitleThai = couponInCell.couponTitleThai
            self.couponDate = couponInCell.couponDate
            self.couponEndDate = couponInCell.couponEndDate
            self.couponDescription = couponInCell.couponDescription
            self.couponDescriptionThai = couponInCell.couponDescriptionThai
            self.couponImage = couponInCell.couponImage
            self.couponLogo = couponInCell.couponLogo
            self.couponPhoneNumber = couponInCell.couponPhoneNumber
            self.couponMap = couponInCell.couponMap
            self.couponEndDay = couponInCell.couponEndDay
            self.daysLeftToExpiration = couponInCell.daysLeftToExpiration
            self.couponSubtitle = couponInCell.couponSubtitle
            self.couponSubtitleThai = couponInCell.couponSubtitleThai
           
            
            performSegueWithIdentifier("couponViewSegue", sender: self)
        }
    }
    
    
    
    func getLocalJsonFile(fileName:String) -> [NSDictionary]{
        print("getting local json file")
        let fileManager = NSFileManager.defaultManager()
    
        if let documentsUrl =  fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL? {
            let urlPath = documentsUrl.URLByAppendingPathComponent(fileName)
            
            let jsonData:NSData? = NSData(contentsOfURL: urlPath)
            print("\(urlPath)")
            
            if let actualJsonData = jsonData {
                do {
                    let arrayOfDictionaries: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                    //self.gotJson = true
                    print ("got json: \(fileName)")
                    return arrayOfDictionaries
                    
                }
                catch{
                    //self.gotJson = false
                    print( "couldn't get the file \(fileName) 1")
                }
            } else {
                 print( "couldn't get the file \(fileName) 2")
                //self.gotJson = false
            }
        }
        else {
             print( "couldn't get the file \(fileName) 3")
            //self.gotJson = false
        }
        return [NSDictionary]()
    }
    
    
    func getEventData() -> [Event]{
        
        var eventsTodayArray:[Event] = [Event]()
        var eventsWeekendArray: [Event] = [Event]()
        var eventsAllArray: [Event] = [Event]()
        var eventsUnsorted: [Event] = self.getEventsUnsortedArray()
        
        //calendar stuff
        let date = NSDate()
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)

        let components = calendar!.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday], fromDate: date)
        let day = components.day
        let year = components.year
        let month = components.month
        
        var index: Int
        for index = 0; index < eventsUnsorted.count; index++ {
            let e = eventsUnsorted[index]
            let eventDateNoTime = "\(e.eventDate[0])"+"-"+"\(e.eventDate[1])"+"-"+"\(e.eventDate[2])"
            let eventFullDate = NSDate(dateString: eventDateNoTime + " " + "\(e.eventTime)"+":00")
            
            let eventEndDateNoTime = "\(e.eventEndDate[0])"+"-"+"\(e.eventEndDate[1])"+"-"+"\(e.eventEndDate[2])"
            let eventFullEndDate = NSDate(dateString: eventEndDateNoTime + " " + "\(e.eventEndTime)"+":00")
            
            let componentsEvent = calendar!.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday], fromDate: eventFullDate)
            
            e.eventDay = componentsEvent.weekday
            e.eventDateFull = eventFullDate
            e.eventEndDateFull = eventFullEndDate
            
            
            let compareDate = eventFullDate.addDays(-7)
            //let dateAdjustedForTime = eventFullDate.addHours(10)
            
            if eventFullEndDate.isLessThanDate(date){
               
            } else {
                
                if e.eventDate[0] == year {
                    if e.eventDate[1] == month {
                        if e.eventDate[2] == day {
                            eventsTodayArray.append(e)
                            
                        } else {
                            if e.eventEndDate[0] == year {
                                if e.eventEndDate[1] == month {
                                    if e.eventEndDate[2] == day {
                                        eventsTodayArray.append(e)
                                    }
                                }
                            }

                            
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
        
    }
    

    
    func getCouponInfo () ->[Coupon]{
        var index:Int
        var listOfCoupons = [Coupon]()
        
        for index = 0; index < self.couponJson.count; index++ {
            
            let jsonDictionary:NSDictionary = self.couponJson[index]
            let couponVenueInfoNoJson = jsonDictionary["couponVenue"] as! String
            let couponVenueInfo = couponVenueInfoNoJson+".json"
            
            
            let venueJsonFile:[NSDictionary] = self.getLocalJsonFile(couponVenueInfo)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            
            let jsonPath = paths.stringByAppendingPathComponent(couponVenueInfo)
            if NSFileManager().fileExistsAtPath(jsonPath){
                let venueJson:NSDictionary = venueJsonFile[0]
                let getCoupon = GetCoupon()
                let coupon = getCoupon.GetCouponInfo(jsonDictionary, venueFile: venueJson)
                
                let daysLeftForCoupon = getCoupon.couponNotExpired(coupon)
                coupon.daysLeftToExpiration = daysLeftForCoupon
                
                if daysLeftForCoupon >= 0 {
                    listOfCoupons.append(coupon)
                }
                
            }
            
        }
        return listOfCoupons
    }
    
    func getNumberOfCouponHeaders () ->[String]{
        var venueArray = [String]()
        var index = 0
        
        for index=0; index < self.couponsToDisplay.count; index++ {
            
            let venueName = self.couponsToDisplay[index].couponVenue
            if venueArray.contains(venueName) {
                
            } else {
            venueArray.append(venueName)
               
            }
            
        }
        print("venueArray is \(venueArray.count) items")
        return venueArray
    }
    
    func getCouponsForEachHeader ()-> NSMutableDictionary{
        let couponsUnderHeaders = NSMutableDictionary()
        var index = 0
        for index=0; index < self.couponsToDisplay.count; index++ {
            let venueNameForThing = self.couponsToDisplay[index].couponVenue
            let couponToAdd = self.couponsToDisplay[index]
            if couponsUnderHeaders[venueNameForThing] == nil {
                couponsUnderHeaders[venueNameForThing] = [couponToAdd]
            } else {
                var couponArray = couponsUnderHeaders[venueNameForThing] as! [Coupon]
                
               
                couponArray.append(couponToAdd)
                
                couponsUnderHeaders[venueNameForThing] = couponArray
                
                               // print("the numberof coupons at couons under header \(venueNameForThing) is \(countAgain)")
            }
          
        }
        return couponsUnderHeaders
    }
    
    func getEventsUnsortedArray () ->[Event]{
        var index: Int
        var eventsUnsorted: [Event] = [Event]()
    
          for index = 0; index < self.jsonObjects.count; index++ {
            let jsonDictionary:NSDictionary = self.jsonObjects[index]
            
            let eventVenueInfoNoJson = jsonDictionary["eventVenue"] as! String
            let eventVenueInfo = eventVenueInfoNoJson+".json"
            
            let venueJsonFile:[NSDictionary] = self.getLocalJsonFile(eventVenueInfo)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString

            let jsonPath = paths.stringByAppendingPathComponent(eventVenueInfo)
            if NSFileManager().fileExistsAtPath(jsonPath){
        
            let venueJson:NSDictionary = venueJsonFile[0]
            let e:Event = Event()
            
            e.eventPlaceName = venueJson["venueName"] as! String
            e.venueLogoImageUrl = venueJson["venueLogoImageUrl"] as! String
            e.phoneNumber = venueJson["venuePhoneNumber"] as! String
            e.venueCoordinates = venueJson["venueCoordinates"] as! [Double]
            e.venueImage = venueJson["venueImage"] as! String
            
            e.eventTitle = jsonDictionary["eventTitle"] as! String
            e.eventTitleThai = jsonDictionary["eventTitleThai"] as! String
            e.eventTime = jsonDictionary["eventTime"] as! String
            e.eventEndTime = jsonDictionary["eventEndTime"] as! String
            
            e.eventDate = jsonDictionary["eventDate"] as! [Int]
            e.eventEndDate = jsonDictionary["eventEndDate"] as! [Int]
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
            
            eventsUnsorted.append(e)
        
            }
        }
        
            
    }
        return eventsUnsorted

    
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
                destinationVC.venuePhone = self.venuePhone
                destinationVC.eventDateFull = self.eventDateFull
                destinationVC.eventTitleThai = self.eventTitleThai
                
            }
                     
        }
        if segue.identifier == "couponViewSegue"
        {
            if let destinationVC = segue.destinationViewController as? CouponViewController{
                
                destinationVC.couponVenue = self.couponVenue
                destinationVC.couponTitle = self.couponTitle
                destinationVC.couponTitleThai = self.couponTitleThai
                destinationVC.couponDate = self.couponDate
                destinationVC.couponEndDate = self.couponEndDate
                destinationVC.couponDescription = self.couponDescription
                destinationVC.couponDescriptionThai = self.couponDescriptionThai
                destinationVC.couponImage = self.couponImage
                destinationVC.couponLogo = self.couponLogo
                destinationVC.couponPhoneNumber = self.couponPhoneNumber
                destinationVC.couponMap = self.couponMap
                destinationVC.couponEndDay = self.couponEndDay
                destinationVC.daysLeftToExpiration = self.daysLeftToExpiration
                destinationVC.couponSubtitle = self.couponSubtitle
                destinationVC.couponSubtitleThai = self.couponSubtitleThai
                
                
                
            }
            
        }

        
        }
    
    
 

    func rotateView(view: UIView, duration: Double = 1) {
        if view.layer.animationForKey(kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(M_PI * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            view.layer.addAnimation(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    func stopRotatingView(view: UIView) {
        if view.layer.animationForKey(kRotationAnimationKey) != nil {
            view.layer.removeAnimationForKey(kRotationAnimationKey)
          
        }
       
    }
    
    
}


