//
//  OtherViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 26/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class OtherViewController: UIViewController {
    @IBOutlet weak var mapButton: UIButton!

    @IBAction func gotoFullscreenPic(_ sender: AnyObject) {
        performSegue(withIdentifier: "fullScreenPicSegue", sender: self)
    }
   
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
    var coreData = CoreData()
    let imageHandler = ImageHandler()
    var event:NSManagedObject!
    var venue:NSManagedObject!
    let prefs = Prefs()
   
    
    let titleByLanguage = ["Thai":"titleThai", "Eng":"title"]
    let descByLanguage = ["Thai":"descThai", "Eng":"desc"]
    var costByLanguage = ["Thai":"", "Eng":""]
    var venueNameKeys = ["Thai":"name", "Eng":"name"]
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let venue = self.event.value(forKey: "venue") as? NSManagedObject {
            self.venue = venue
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "Venue", in: context)
            self.venue = NSManagedObject(entity: entity!, insertInto: context)
        }
        
        let imageName = self.event.stringValue("imageName")
        let logoName = self.venue.stringValue("logoName")
        
        self.eventImage.image = self.imageHandler.getImageData(imageName)
       self.logoButton.setImage(self.imageHandler.getImageData(logoName), for: UIControlState())
        self.thaiButton.alpha = 0.8
        self.englishButton.alpha = 0.8
        
        // Format entry cost
        if event.stringValue("cost") == "free" {
            self.costByLanguage["Thai"] = "เข้างานฟรี!"
            self.costByLanguage["Eng"] = "Free Entry!"
        } else {
            self.costByLanguage["Thai"] = "เข้างาน ฿" + self.event.stringValue("cost")
            self.costByLanguage["Eng"] = "Entry: " + self.event.stringValue("cost") + "Baht"
        }
        self.toggleLanguage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatAttributedText(_ typefaceName:String, fontSize:CGFloat, lineSpacing:CGFloat, textToFormat:String) ->NSAttributedString {
        let attrib = [NSFontAttributeName: UIFont(name:typefaceName, size: fontSize)!]
        let attributedText = NSMutableAttributedString(string: textToFormat, attributes: attrib)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = NSTextAlignment.center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        return attributedText
    }
    

    
    @IBAction func thaiButtonPress(_ sender: AnyObject) {
        self.prefs.thaiOn = true
        self.prefs.set()
        self.toggleLanguage()
    }
    
    @IBAction func englishButtonPress(_ sender: AnyObject) {
        self.prefs.thaiOn = false
        self.prefs.set()
        self.toggleLanguage()
    }
    
    @IBAction func calendarButtonPress(_ sender: AnyObject) {
        var messageTitle = ""
        var messageContents = ""
        let getDate = EnterDate()
        
        let eventSaved = getDate.requestAccessPermission(self.event.stringValue(self.titleByLanguage[self.prefs.language]!), startDate: self.event.dateValue("date"), endDate: self.event.dateValue("endDate"),place:self.venue.stringValue(self.venueNameKeys[self.prefs.language]!))
        
        if eventSaved == true {
            messageTitle = "KK Nightlife"
            messageContents = "Event Saved!"
        } else {
            messageTitle = "Error!"
            messageContents = "Event not saved to calendar for some reason"
            
        }
        let alertThing = UIAlertController(title: messageTitle, message:
            messageContents, preferredStyle: UIAlertControllerStyle.alert)
        alertThing.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
            handler: nil))

        self.present(alertThing, animated: true, completion: nil)
    }
    
    @IBAction func mapButtonPress(_ sender: AnyObject) {
     
        
           let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:self.venue.doubleValue("coordinates1"), longitude:self.venue.doubleValue("coordinates2")), addressDictionary: nil))
        
       mapItem.name = self.venue.stringValue(self.venueNameKeys[self.prefs.language]!)
    
        mapItem.openInMaps(launchOptions: nil)
        
    }

    @IBAction func fbButtonPress(_ sender: AnyObject) {
                  UIApplication.shared.openURL(URL(string: self.event.stringValue("url"))!)
           }
    
   
    @IBAction func phoneButtonPress(_ sender: AnyObject) {
        let phoneNumber = "tel://" + self.venue.stringValue("phoneNumber")
        let url = URL(string: phoneNumber)!
        UIApplication.shared.openURL(url)
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
       var activityItems = [AnyObject]()
        
        let firstActivityItem = "I am going to attend \(self.event.stringValue(self.titleByLanguage["Eng"]!)) at \(self.venue.stringValue(self.venueNameKeys["Eng"]!))! Care to join me? \nฒันจะไป \(self.event.stringValue(self.titleByLanguage["Thai"]!)) ที่ \(self.venue.stringValue("nameThai"))! คุณอยากจะไปกับฉันไหม"
        let secondActivityItem : URL = URL(string:  self.event.stringValue("url"))!
        let thirdActivityItem = "\n - Find out what's happening in Khon Kaen with the Khon Kaen Nighlife app for IOS -\nหากท่านกำลังมองหาแหล่งบันเทิง นี่เลย! Khon Kaen Nightlife! \nhttp://appstore.com/khonkaennightlife"
        
        
            let image : UIImage = self.eventImage.image!
            activityItems = [firstActivityItem as AnyObject, secondActivityItem as AnyObject, image, thirdActivityItem as AnyObject]
        
            
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
    
    @IBAction func LogoButton(_ sender: AnyObject) {
        
       
        UIApplication.shared.openURL(URL(string:self.venue.stringValue("url"))!)
        
    }
    
    
    
    func toggleLanguage () {
        if self.prefs.thaiOn {
            self.dateLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
            self.entryCostLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 32)
            self.eventDescription.font = UIFont(name: "DBHelvethaicaX-35Thin", size: 25)
            self.eventTitleLabel.font = UIFont(name: "DBHelvethaicaX-36ThinIt", size: 42)
        } else {
            self.dateLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
            self.entryCostLabel.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 23)
            self.eventDescription.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
            self.eventTitleLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        }
        
        self.thaiButton.isEnabled = !self.prefs.thaiOn
        self.englishButton.isEnabled = self.prefs.thaiOn
        
        if let eventDate = self.event.value(forKey: "date") as? Date {
            self.dateLabel.text = eventDate.string(self.prefs.language, dateFormat: ["Thai":"EEEE ที่ d MMM", "Eng":"EEEE, MMMM d"])
        }
        self.eventTitleLabel.text = event.stringValue(self.titleByLanguage[self.prefs.language]!)
        
        self.eventDescription.text = event.stringValue(self.descByLanguage[self.prefs.language]!)
        self.entryCostLabel.text = self.costByLanguage[self.prefs.language]!
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullScreenPicSegue"
        {
            if let destinationVC = segue.destination as? EventPicViewController{
                destinationVC.eventImage = self.eventImage.image!
            }
            
        }

    }
   

}
