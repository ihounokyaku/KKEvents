//
//  CouponViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 1/25/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import MapKit

class CouponViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var titleEnglish: UILabel!
    @IBOutlet weak var titleThai: UILabel!
    @IBOutlet weak var subtitleEnglish: UILabel!
    @IBOutlet weak var subtitleThai: UILabel!
    
    @IBOutlet weak var couponDescriptionLabel: UILabel!
    
    var couponVenue = ""
    var couponTitle = ""
    var couponTitleThai = ""
    var couponSubtitle = ""
    var couponSubtitleThai = ""
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
    var couponLogoImage = UIImage()
    var venuePhone = ""
    var venueUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gimage = GetImage()
        self.couponLogoImage = gimage.getImageFromDocuments(self.couponLogo)
      
        self.logoImage.image = self.couponLogoImage
        
        self.titleEnglish.font = UIFont(name: "DBHelvethaicaX-46LiIt", size: 32)
        self.titleEnglish.text = self.couponTitle
        self.titleThai.text = self.couponTitleThai
        self.subtitleEnglish.text = self.couponSubtitle
        self.subtitleThai.text = self.couponSubtitleThai
        if self.couponDescription != "" {
            if self.couponDescriptionThai != "" {
                self.couponDescriptionLabel.text = self.couponDescription
            } else {
                self.couponDescriptionThai = self.couponDescription
                 self.couponDescriptionLabel.text = self.couponDescription
            }
        } else {
            self.couponDescription = self.couponDescriptionThai
            self.couponDescriptionLabel.text = self.couponDescription
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    
    


@IBAction func mapButtonPress(sender: AnyObject) {
    
    
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:self.couponMap[0], longitude:self.couponMap[1]), addressDictionary: nil))
    
    mapItem.name = self.couponVenue
    
    mapItem.openInMapsWithLaunchOptions(nil)
    
}



@IBAction func phoneButtonPress(sender: AnyObject) {
    let phoneNumber = "tel://"+self.venuePhone
    let url = NSURL(string: phoneNumber)!
    UIApplication.sharedApplication().openURL(url)
}

@IBAction func shareButtonPressed(sender: AnyObject) {
    var activityItems = [AnyObject]()
    
    let firstActivityItem = "Check out this promotion going on at: \(self.couponVenue)! \n\(self.couponTitle)! \(self.couponSubtitle)\nCare to join me? \n"
    
    let thirdActivityItem = "\n - Get great deals and find out what's happening in Khon Kaen with the Khon Kaen Events app for IOS -"
    
    if self.venueUrl != "" {
        let secondActivityItem : NSURL = NSURL(string: self.venueUrl)!
        
        activityItems = [firstActivityItem, secondActivityItem, thirdActivityItem]
    } else {
        activityItems = [firstActivityItem, thirdActivityItem]
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
    
    if self.venueUrl != ""{
        UIApplication.sharedApplication().openURL(NSURL(string:self.venueUrl)!)
    }
    }
}

