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
   
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var venueLogo: UIImageView!
    
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      
        
        let gimage = GetImage()
        let eventImageName = eventImageURL
        let eventImageToUse:UIImage = gimage.getImageFromDocuments(eventImageName)
        let logoImageName = logo
        let logoImageToUse:UIImage = gimage.getImageFromDocuments(logoImageName)
        
        
        self.eventImage.image = eventImageToUse
        self.venueLogo.image = logoImageToUse
        self.thaiButton.alpha = 0.8
        self.englishButton.alpha = 0.8
        self.eventImageFile = eventImageToUse
        
        //self.eventTitleLabel.font = UIFont.systemFontOfSize(20)
        self.eventTitleLabel.text = self.eventTitle
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
        
        if eventDeets != "" {
            if eventDeetsThai != "" {
                self.englishButton.enabled = true
                self.thaiButton.enabled = false
                //self.eventTitleLabel.font = UIFont(name: "Thonburi Light", size: 32)
                self.dateLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
                self.entryCostLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
                //self.eventDescription.font = UIFont(name: "DBHelvethaicaX-35Thin", size: 25)
                self.eventDescription.attributedText = self.formatAttributedText("DBHelvethaicaX-35Thin", fontSize: 20, lineSpacing: 0.1, textToFormat: self.eventDeetsThai)
                //self.eventDescription.text = self.eventDeetsThai
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
        self.eventDescription.font = UIFont(name: "DBHelvethaicaX-35Thin", size: 22)
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
        self.eventDescription.text = self.eventDeets
        self.dateLabel.text = self.eventDate
        self.entryCostLabel.text = self.entryCost
    }
    
    @IBAction func mapButtonPress(sender: AnyObject) {
     
        
           let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:self.venueCoordinates[0], longitude:self.venueCoordinates[1]), addressDictionary: nil))
        
       mapItem.name = self.venueName
    
        mapItem.openInMapsWithLaunchOptions(nil)
        
    }

    @IBAction func fbButtonPress(sender: AnyObject) {
        let facebookURL = NSURL(string: "fb://profile/PageId")!
        if UIApplication.sharedApplication().canOpenURL(facebookURL) {
            UIApplication.sharedApplication().openURL(facebookURL)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: eventURL)!)
        }
    }
    
    @IBAction func LogoButton(sender: AnyObject) {
        
        if self.venueURL != ""{
        UIApplication.sharedApplication().openURL(NSURL(string:self.venueURL)!)
        }
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
