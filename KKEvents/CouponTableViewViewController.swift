//
//  CouponTableViewViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 11/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CouponTableViewViewController: MainViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var couponTable: UITableView!
    
    var couponsUnderHeaders = NSMutableDictionary()
    let keysByLanguage = ["Eng":["title", "subtitle", "desc","name"],"Thai":["titleThai", "subtitleThai", "descThai", "nameThai"]]
    
    var venueNameSelected = "someplace"
    var titleSelected = "Super Deal!"
    
    
    // coupon info to send to couponview
    var promotionSelected:NSManagedObject?
    var venueSelected:NSManagedObject?
    
    var loadNumber = 0
    
    //Coupon showing
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var mainTitleEnglish: UILabel!
  
    @IBOutlet weak var subTitleEnglish: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.couponTable.delegate = self
        self.couponTable.dataSource = self
        self.toggleLanguage()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func thaiButtonPushed(_ sender: AnyObject) {
        self.navDelegate.prefs.thaiOn = true
        self.navDelegate.prefs.set()
        self.toggleLanguage()
    }
    
    @IBAction func englishButtonPushed(_ sender: AnyObject) {
        self.navDelegate.prefs.thaiOn = false
        self.navDelegate.prefs.set()
        self.toggleLanguage()
    }
    
    
    func toggleLanguage () {
        self.thaiButton.isEnabled = !self.navDelegate.prefs.thaiOn
        self.englishButton.isEnabled = self.navDelegate.prefs.thaiOn
        if let promotion = promotionSelected {
        self.mainTitleEnglish.text = promotion.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![0])
        self.subTitleEnglish.text = promotion.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![1])
        self.descLabel.text = promotion.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![2])
        }
    }
    
    func venueKey(_ keys:[String:String], forID:String)-> String {
        var venueName = forID
        
        if let venue = self.navDelegate.coreData.objectWithID(forID, ofType: "Venue") {
            if let name = venue.value(forKey: keys[self.navDelegate.prefs.language]!) as? String {
                venueName = name
            }
        }
        return venueName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("the number of promotion venues is \(self.navDelegate.coreData.promotionVenues.count)")
      return self.navDelegate.coreData.promotionVenues.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let venueName = self.navDelegate.coreData.promotionVenues[section]
        if let promotionsAtVenue = self.navDelegate.coreData.promotionsByVenue[venueName] {
            return promotionsAtVenue.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let header = UIView()
        print("getting header")
        
        header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        let headerCenterX = tableView.frame.width / 2
        let headerCenterY = header.frame.height  / 2
        let imageSize = header.frame.height - 5
        
        let headerColor = "294d69"
        header.backgroundColor = headerColor.UIColorFromRGB()
        let frame = CGRect(x: 15, y: 0, width: imageSize, height: imageSize)
        let customView: UIImageView = UIImageView(frame: frame)
        
        
        customView.center.y = headerCenterY
        
        let venueID = self.navDelegate.coreData.promotionVenues[section]
        let venueName = self.venueKey(["Eng":"name", "Thai":"nameThai"], forID: venueID)
        let venueLogoName = self.venueKey(["Eng":"logoName", "Thai":"logoName"], forID: venueID)
        customView.image = self.navDelegate.imageHandler.getImageData(venueLogoName)
        
        let attrib = [NSFontAttributeName: UIFont(name: "DBHelvethaicaX-Li", size: 25)!]
        let placeName = NSMutableAttributedString(string:venueName, attributes:attrib)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let titleColor = "accae1"
        titleLabel.textColor = titleColor.UIColorFromRGB()

        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.attributedText = placeName
        titleLabel.center.y = headerCenterY
        titleLabel.center.x = headerCenterX + 20

        titleLabel.alpha = 1
        header.addSubview(titleLabel)
        header.addSubview(customView)
            
 
        return header
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let venueNameForSection = self.navDelegate.coreData.promotionVenues[indexPath.section]
        let cellsInSection = self.navDelegate.coreData.promotionsByVenue[venueNameForSection]
        let promotion = cellsInSection![indexPath.row]
        
        //set attributes
        let attrib = [NSFontAttributeName: UIFont(name: "DBHelvethaicaX-36ThinIt", size: 33)!]
        let attrib2 = [NSFontAttributeName: UIFont(name: "DBHelvethaicaX-Li", size: 20)!]
        
        
        let title = NSMutableAttributedString(string: promotion.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![0]), attributes:attrib)
        let color1 = "294d69"
        title.addAttribute(NSForegroundColorAttributeName, value: color1.UIColorFromRGB(), range: NSMakeRange(0, title.length))
        
        //set expiration
        let date = Date()
        var expirationString = ""
        var textColor = "c83f27"
        var daysLeftToExpiration = 1
        if let endDate = promotion.value(forKey: "endDate") as? Date{
            daysLeftToExpiration = date.daysUntil(endDate)
        }
        
        if daysLeftToExpiration > 2 {
            expirationString = "Expires in \(daysLeftToExpiration) days / หมดโปรภายใน \(daysLeftToExpiration) วัน"
            textColor = "294d69"
        } else if daysLeftToExpiration == 2 {
            expirationString = "EXPIRES TOMORROW! / หมดโปรพรุ่งนี้!"
        } else {
            expirationString = "EXPIRES TODAY! / หมดโปรวันนี้!"
        }
        
        let expirationDate = NSMutableAttributedString(string:"\n" + expirationString, attributes:attrib2)
        expirationDate.addAttribute(NSForegroundColorAttributeName, value: textColor.UIColorFromRGB(), range: NSMakeRange(0, expirationDate.length))
        
        title.append(expirationDate)
        
        cell.textLabel!.attributedText = title
        cell.textLabel!.textAlignment = NSTextAlignment.center
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        
        cell.textLabel!.numberOfLines = 0
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let venueID = self.navDelegate.coreData.promotionVenues[indexPath.section]
        let cellsInSection = self.navDelegate.coreData.promotionsByVenue[venueID]
        let promotion = cellsInSection![indexPath.row]
        
        self.venueSelected = self.navDelegate.coreData.objectWithID(venueID, ofType: "Venue")
        self.promotionSelected = promotion
        
        let venueLogoName = self.venueKey(["Eng":"logoName", "Thai":"logoName"], forID: venueID)
        
        
        self.couponView.alpha = 0
        self.couponView.isHidden = false
        
        
        
        self.mainTitleEnglish.text = promotion.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![0])
        self.titleSelected = promotion.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![0])
        
        
        if let subtitle = promotion.value(forKey: self.keysByLanguage[self.navDelegate.prefs.language]![1]) as? String {
            self.subTitleEnglish.text = subtitle
        }
        
        if let desc = promotion.value(forKey: self.keysByLanguage[self.navDelegate.prefs.language]![2]) as? String {
            self.descLabel.text = desc
        }

        self.couponImageView.image = self.navDelegate.imageHandler.getImageData(venueLogoName)
        
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.couponView.alpha = 1
            }, completion:nil)
    }
    
       @IBAction func xButtonPressed(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.5, animations: {
            self.couponView.alpha = 0.0
            }, completion:{ finished in
            self.couponView.isHidden = true
            })
    }
    
   

    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        var activityItems = [AnyObject]()
        
        let firstActivityItem = "Check out this promotion going on at: \(self.venueSelected!.stringValue("name"))! \n\(self.promotionSelected!.stringValue("title"))! \(self.promotionSelected!.stringValue("subtitle")))\nCare to join me? \nโปรโมชั่นวันนี้ที่ \(self.venueSelected!.stringValue("nameThai")):\n\(self.promotionSelected!.stringValue("titleThai"))! ไปด้วยกันไหม?"
        
        let thirdActivityItem = "\n - Get great deals and find out what's happening in Khon Kaen with the Khon Kaen Events app for IOS --\nหากท่านกำลังมองหาแหล่งบันเทิง นี่เลย! Khon Kaen Nightlife!\nhttp://appstore.com/khonkaennightlife"
        
        if let temp = self.venueSelected!.value(forKey: "url") as? String {
            let secondActivityItem : URL = URL(string: temp)!
            
            activityItems = [firstActivityItem as AnyObject, secondActivityItem as AnyObject, thirdActivityItem as AnyObject]
        } else {
            activityItems = [firstActivityItem as AnyObject, thirdActivityItem as AnyObject]
        }
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)

    }

    @IBAction func phoneButtonPressed(_ sender: AnyObject) {
        

        let phoneNumber = "tel://"+self.venueSelected!.stringValue("phoneNumber")
        let url = URL(string: phoneNumber)!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func mapButtonSpressed(_ sender:AnyObject) {
        
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:(self.venueSelected!.value(forKey: "coordinates1") as! Double) , longitude:self.venueSelected!.value(forKey: "coordinates2") as! Double), addressDictionary: nil))
        
        
        mapItem.name = venueSelected!.stringValue(self.keysByLanguage[self.navDelegate.prefs.language]![3])
        
        mapItem.openInMaps(launchOptions: nil)
    }
   
    @IBAction func imageButtonPressed(_ sender: AnyObject) {
        let url = venueSelected!.stringValue("url")
        
            UIApplication.shared.openURL(URL(string:url)!)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
