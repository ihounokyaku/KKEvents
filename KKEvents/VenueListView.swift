//
//  VenueListView.swift
//  KKEvents
//
//  Created by Southard Dylan on 8/3/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VenueListView: MainViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noVenuesLabel: UILabel!
    

    var urlList = [NSDictionary]()
    
    var venueNames = [String]()
    var venueSelected:NSManagedObject!
    var loadNumber = 0

    let titleLabelText = ["Eng":"Venues", "Thai":"รายละเอียดร้าน"]
    let mapLabelText = ["Eng":"See Map", "Thai":"ดูแผ่นที่"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        for venue in self.navDelegate.coreData.venues {
            self.venueNames.append(venue.stringValue(self.navDelegate.coreData.venueNameKeys[self.navDelegate.prefs.language]!))
        }
        self.titleLabel.text =  self.titleLabelText[self.navDelegate.prefs.language]!
        self.mapLabel.text = self.mapLabelText[self.navDelegate.prefs.language]!

        }

        // Do any additional setup after loading the view.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("view did appear")
        self.navDelegate.prefs.refresh()
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.navDelegate.coreData.venues.count == 0 {
            self.noVenuesLabel.isHidden = false
            let noVenuesText = ["Eng":"hmmmmmm...\n\n it appears that none of the venues have shown up. This definitely should not be happening.\n\nPlease check your internet connection again and press the spinny arrow button in the top right corner of the home page to refresh.", "Thai":"ไม่มีข้อมูลร้าน กรุณาตรวจสอบการเชื่อมต่ออินเตอร์เน็ต กลับไปหน้าหลัก กดลูกศรข้างบนเพื่อโหลดข้อมูลใหม่อีกครั้ง"]
           
                self.noVenuesLabel.text = noVenuesText[self.navDelegate.prefs.language]!
        }else {
            self.noVenuesLabel.text = ""
            self.noVenuesLabel.isHidden = true
        }
        return self.navDelegate.coreData.venues.count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VenueCollectionViewCell
        let venue = self.navDelegate.coreData.venues[indexPath.item]
        let logoName = venue.stringValue("logoName")
       
        cell.image.image = self.navDelegate.imageHandler.getImageData(logoName)
        cell.label.text = self.venueNames[indexPath.item]
        
        cell.backgroundColor = UIColor.white

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.venueSelected = self.navDelegate.coreData.venues[indexPath.item]
        
        performSegue(withIdentifier: "venueSegue", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "venueSegue"
        {
            if let destinationVC = segue.destination as? VenueViewController{
                destinationVC.venue = self.venueSelected
            }
        }
    }
 
    @IBAction func pressMapButton(_ sender: AnyObject) {
        var mapItemArray = [MKMapItem]()

        for venue in self.navDelegate.coreData.venues {
            if (venue.value(forKey: "coordinates1") as! Double) != 0.0 && (venue.value(forKey: "coordinates2") as! Double) != 0.0 {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:(venue.value(forKey: "coordinates1") as! Double), longitude:(venue.value(forKey: "coordinates2") as! Double)), addressDictionary: nil))
                mapItem.name = venue.stringValue(self.navDelegate.coreData.venueNameKeys[self.navDelegate.prefs.language]!)
                mapItem.phoneNumber = venue.stringValue("phoneNumber")
                let fbUrl = URL(string: venue.stringValue("urlFB"))
                if let actualUrl = fbUrl {
                    
                   mapItem.url = actualUrl
                }
               
                mapItemArray.append(mapItem)
                
            }
        }

        //let location = locations.last as CLLocation

        MKMapItem.openMaps(with: mapItemArray, launchOptions: nil)
        
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        print("unwind to home")
        self.navDelegate.prefs.refresh()
        self.venueNames = []
        for venue in self.navDelegate.coreData.venues {
            self.venueNames.append(venue.stringValue(self.navDelegate.coreData.venueNameKeys[self.navDelegate.prefs.language]!))
           
        }
        self.titleLabel.text =  self.titleLabelText[self.navDelegate.prefs.language]!
        self.mapLabel.text = self.mapLabelText[self.navDelegate.prefs.language]!

        self.collectionView.reloadData()
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
