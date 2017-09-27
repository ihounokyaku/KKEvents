//
//  VenueViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 8/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VenueViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueDescriptionLabel: UILabel!
    @IBOutlet weak var venueLogoImageView: UIImageView!

    @IBOutlet weak var thaiFlagButton: UIButton!
    @IBOutlet weak var ukFlagButton: UIButton!
    
    var venue:NSManagedObject!
    var loadNumber = 0
    var prefs = Prefs()
    let imageHandler = ImageHandler()
    let languageKeys = ["Eng":["name","desc"], "Thai":["nameThai", "descThai"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoName = self.venue.stringValue("logoName")
        let bkgImageName = self.venue.stringValue("bkgImageName")
        self.venueLogoImageView.image = self.imageHandler.getImageData(logoName)
        self.backgroundImageView.image = self.imageHandler.getImageData(bkgImageName)
        self.toggleLanguage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func facebookPress(_ sender: AnyObject) {
        let fbUrl = URL(string: self.venue.stringValue("urlFB"))
        if let actualUrl = fbUrl {
        
        UIApplication.shared.openURL(actualUrl)
        }
    }
    @IBAction func phonePress(_ sender: AnyObject) {
            let phoneNumber = "tel://"+self.venue.stringValue("phoneNumber")
            let url = URL(string: phoneNumber)
            if let actualUrl = url {
                UIApplication.shared.openURL(actualUrl)
            }
    }
    @IBAction func mapPress(_ sender: AnyObject) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:(self.venue.value(forKey: "coordinates1") as! Double), longitude:(self.venue.value(forKey: "coordinates2") as! Double)), addressDictionary: nil))
        
        mapItem.name = self.venue.stringValue(self.languageKeys[prefs.language]![0])
        
        mapItem.openInMaps(launchOptions: nil)
        
        
    }
    
    @IBAction func ukButtonPress(_ sender: AnyObject) {
        self.prefs.thaiOn = false
        self.prefs.set()
        self.toggleLanguage()
    }
    @IBAction func thaiButtonPress(_ sender: AnyObject) {
        self.prefs.thaiOn = true
        self.prefs.set()
        self.toggleLanguage()
    }
    
    
    func toggleLanguage() {
        self.thaiFlagButton.isEnabled = !self.prefs.thaiOn
        self.ukFlagButton.isEnabled = self.prefs.thaiOn
        self.venueNameLabel.text = self.venue.stringValue(self.languageKeys[self.prefs.language]![0])
        self.venueDescriptionLabel.text = self.venue.stringValue(self.languageKeys[self.prefs.language]![1])
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
