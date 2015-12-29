//
//  OtherViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 26/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {
    @IBOutlet weak var mapButton: UIButton!

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var venueLogo: UIImageView!
    
    @IBOutlet weak var entryCostLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    
    
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    
   // var thai = true
    // var english = false
    
    
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.eventImage.image = UIImage(named:eventImageURL)
        self.venueLogo.image = UIImage(named:self.logo)
        self.thaiButton.alpha = 0.8
        self.englishButton.alpha = 0.8
       
        self.eventTitleLabel.text = self.eventTitle
        // Format entry cost
        if self.entryNumber == "free" {
            self.entryCostThai = "เข้างานฟรี!"
            self.entryCost = "Free Entry!"
        } else {
            self.entryCostThai = "เข้างาน ฿\(self.entryNumber)"
            self.entryCost = "Entry: ฿\(self.entryNumber)"
        }
        
        // check for both languages
        
        if eventDeets != "" {
            if eventDeetsThai != "" {
                self.englishButton.enabled = true
                self.thaiButton.enabled = false
                self.eventDescription.text = self.eventDeetsThai
                self.dateLabel.text = self.eventDateThai
                self.entryCostLabel.text = self.entryCostThai
                
            } else {
                self.englishButton.enabled = false
                self.thaiButton.enabled = false
                self.thaiButton.hidden = true
                self.englishButton.hidden = true
                self.dateLabel.text = self.eventDate
                self.eventDescription.text = self.eventDeets
                self.entryCostLabel.text = self.entryCost
            }
        } else if eventDeetsThai != "" {
            self.englishButton.enabled = false
            self.thaiButton.enabled = false
            self.thaiButton.hidden = true
            self.englishButton.hidden = true
            self.dateLabel.text = self.eventDateThai
            self.eventDescription.text = self.eventDeetsThai
            self.entryCostLabel.text = self.entryCostThai
        } else {
            self.englishButton.enabled = false
            self.thaiButton.enabled = false
            self.thaiButton.hidden = true
            self.englishButton.hidden = true
            self.dateLabel.text = self.eventDate
            self.entryCostLabel.text = self.entryCost
            self.eventDescription.text = "no description available \n ไม่มีข้อมูลรายละเอียดของอีเวนท์นี้"
        }
        
        
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func thaiButtonPress(sender: AnyObject) {
        thaiButton.enabled = false
        englishButton.enabled = true
        self.eventDescription.text = self.eventDeetsThai
        self.dateLabel.text = self.eventDateThai
        self.entryCostLabel.text = self.entryCostThai
    }
    
    @IBAction func englishButtonPress(sender: AnyObject) {
        thaiButton.enabled = true
        englishButton.enabled = false
        self.eventDescription.text = self.eventDeets
        self.dateLabel.text = self.eventDate
        self.entryCostLabel.text = self.entryCost
    }
    
    @IBAction func mapButtonPress(sender: AnyObject) {print("PRESSEDMAPBUTTON!")
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
