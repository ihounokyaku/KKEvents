//
//  OtherViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 26/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit
import MapKit


class OtherViewController: UIViewController {
    @IBOutlet weak var mapButton: UIButton!

    @IBAction func gotoFullscreenPic(sender: AnyObject) {
        performSegueWithIdentifier("fullScreenPicSegue", sender: self)
    }
   let prefs = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var entryCostLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
   // @IBOutlet weak var venueBackImage: UIImageView!
    
    
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    
   // var thai = true
    // var english = false
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    var eventDeets = ""
    var eventDeetsThai = ""
    var eventImageURL = ""
    var eventTitle = ""
    var eventTitleThai = ""
    var logo = ""
    var eventDate = ""
    var eventDateThai = ""
    var entryCost = ""
    var entryCostThai = ""
    var entryNumber = ""
    var venueName = ""
    var venueCoordinates = [0.0,0.0]
    var eventURL = ""
    var venueURL = ""
    var venueImage = ""
    var eventImageFile:UIImage = UIImage()
    var venuePhone = ""
    var eventDateFull:NSDate = NSDate()
    
    var thaiOn = true

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let temp = NSUserDefaults.standardUserDefaults().objectForKey("Language") as? Bool {
            self.thaiOn = temp
        }
        
        let gimage = GetImage()
        let eventImageName = eventImageURL
        let eventImageToUse:UIImage = gimage.getImageFromDocuments(eventImageName)
        let logoImageName = logo
        let logoImageToUse:UIImage = gimage.getImageFromDocuments(logoImageName)
        
        
        self.eventImage.image = eventImageToUse
       self.logoButton.setImage(logoImageToUse, forState: UIControlState.Normal)
        //self.logoButton.backgroundImageForState(UIControlState.Normal) = logoImageToUse
        //self.logoButton.imageView!.image = logoImageToUse
        self.thaiButton.alpha = 0.8
        self.englishButton.alpha = 0.8
        self.eventImageFile = eventImageToUse
        
        //self.eventTitleLabel.font = UIFont.systemFontOfSize(20)
       
       // self.eventTitleLabel.sizeToFit()
        // set bkg image
      //  self.venueBackImage.alpha = 0.8
        //if self.venueImage != "" {
          //  self.venueBackImage.image = UIImage(named:venueImage)
        //}
        
        // Format entry cost
        if self.entryNumber == "free" {
            self.entryCostThai = "เข้างานฟรี!"
            self.entryCost = "Free Entry!"
        } else {
            self.entryCostThai = "เข้างาน ฿\(self.entryNumber)"
            self.entryCost = "Entry: \(self.entryNumber) Baht"
        }
        
        
        
        // check for both languages
        if eventTitleThai == "" {
            self.eventTitleThai = self.eventTitle
        } else if eventTitle == ""{
            self.eventTitleLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 42)
            self.eventTitle = self.eventTitleThai
            
        } else {
            
        }
        if eventDeets != "" {
            if eventDeetsThai != "" {
                self.englishButton.enabled = true
                self.thaiButton.enabled = false
                //self.eventTitleLabel.font = UIFont(name: "Thonburi Light", size: 32)
                self.dateLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
                self.entryCostLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
                self.eventDescription.font = UIFont(name: "DBHelvethaicaX-35Thin", size: 25)
                self.eventTitleLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 42)
                self.eventTitleLabel.text = self.eventTitleThai
                self.eventDescription.text = self.eventDeetsThai
                self.dateLabel.text = self.eventDateThai
                self.entryCostLabel.text = self.entryCostThai
                
                
            } else {
                self.englishButton.enabled = false
                self.thaiButton.enabled = false
                self.thaiButton.hidden = true
                self.englishButton.hidden = true
                self.dateLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
                self.entryCostLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
                self.eventDescription.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
                 self.eventTitleLabel.text = self.eventTitle
                self.dateLabel.text = self.eventDate
                self.eventDescription.text = self.eventDeets
               
                self.entryCostLabel.text = self.entryCost
            }
        } else if eventDeetsThai != "" {
            self.englishButton.enabled = false
            self.thaiButton.enabled = false
            self.thaiButton.hidden = true
            self.englishButton.hidden = true
            self.dateLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
            self.eventDescription.font = UIFont(name: "DBHelvethaicaX-35Thin", size: 25)
            self.eventTitleLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 42)
            self.eventTitleLabel.text = self.eventTitleThai
            self.dateLabel.text = self.eventDateThai
            self.eventDescription.text = self.eventDeetsThai
            self.entryCostLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
             //self.entryCostLabel.font = UIFont(name: "Thonburi-Light", size: 10.0)
            self.entryCostLabel.text = self.entryCostThai
        } else {
            self.englishButton.enabled = false
            self.thaiButton.enabled = false
            self.thaiButton.hidden = true
            self.englishButton.hidden = true
            self.dateLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
            self.entryCostLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
            self.eventDescription.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
             self.eventTitleLabel.text = self.eventTitle
            self.dateLabel.text = self.eventDate
            self.entryCostLabel.text = self.entryCost
            self.eventDescription.text = "no description available \n ไม่มีข้อมูลรายละเอียดของอีเวนท์นี้"
        }
        
       // self.eventDescription.sizeToFit()
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatAttributedText(typefaceName:String, fontSize:CGFloat, lineSpacing:CGFloat, textToFormat:String) ->NSAttributedString {
        let attrib = [NSFontAttributeName: UIFont(name:typefaceName, size: fontSize)!]
        let attributedText = NSMutableAttributedString(string: textToFormat, attributes: attrib)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = NSTextAlignment.Center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
    

    
    @IBAction func thaiButtonPress(sender: AnyObject) {
        thaiButton.enabled = false
        englishButton.enabled = true
        self.dateLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
        self.entryCostLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
        self.eventDescription.font = UIFont(name: "DBHelvethaicaX-35Thin", size: 25)
        self.eventTitleLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 42)
        self.eventTitleLabel.text = self.eventTitleThai
        self.eventDescription.text = self.eventDeetsThai
        self.dateLabel.text = self.eventDateThai
        self.entryCostLabel.text = self.entryCostThai
    }
    
    @IBAction func englishButtonPress(sender: AnyObject) {
        thaiButton.enabled = true
        englishButton.enabled = false
        self.dateLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
        self.entryCostLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
        self.eventDescription.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        self.eventTitleLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
         self.eventTitleLabel.text = self.eventTitle
        self.eventDescription.text = self.eventDeets
        self.dateLabel.text = self.eventDate
        self.entryCostLabel.text = self.entryCost
    }
    
    @IBAction func calendarButtonPress(sender: AnyObject) {
        let getDate = EnterDate()
        var alertThing = UIAlertController()
        alertThing = getDate.requestAccessPermission(self.eventTitle, startDate: self.eventDateFull, place:self.venueName)
        self.presentViewController(alertThing, animated: true, completion: nil)
    }
    
    @IBAction func mapButtonPress(sender: AnyObject) {
     
        
           let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:self.venueCoordinates[0], longitude:self.venueCoordinates[1]), addressDictionary: nil))
        
       mapItem.name = self.venueName
    
        mapItem.openInMapsWithLaunchOptions(nil)
        
    }

    @IBAction func fbButtonPress(sender: AnyObject) {
                  UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/events/"+eventURL)!)
           }
    
   
    @IBAction func phoneButtonPress(sender: AnyObject) {
        let phoneNumber = "tel://"+self.venuePhone
        let url = NSURL(string: phoneNumber)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
       var activityItems = [AnyObject]()
        
        let firstActivityItem = "I am going to attend \(self.eventTitle) at \(self.venueName)! Care to join me? \n"
        let secondActivityItem : NSURL = NSURL(string:  "https://www.facebook.com/events/"+self.eventURL)!
        let thirdActivityItem = "\n - Find out what's happening in Khon Kaen with the Khon Kaen Events app for IOS -"
        // If you want to put an image
        if self.eventImageURL != ""{
            let image : UIImage = self.eventImageFile
            activityItems = [firstActivityItem, secondActivityItem, image, thirdActivityItem]
        
            
        } else {
            activityItems = [firstActivityItem, secondActivityItem, thirdActivityItem]
            
        }
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func LogoButton(sender: AnyObject) {
        
        if self.venueURL != ""{
        UIApplication.sharedApplication().openURL(NSURL(string:self.venueURL)!)
        }
    }
    
    func saveStuff() {
        NSUserDefaults.standardUserDefaults().setObject(self.thaiOn, forKey: "Language")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fullScreenPicSegue"
        {
            if let destinationVC = segue.destinationViewController as? EventPicViewController{
                destinationVC.eventImage = self.eventImageFile
                
            }
            
        }

    }
   

}
