//
//  OtherViewController.swift
//  KKEvents
//
//  Created by Southard Dylan on 26/12/15.
//  Copyright © 2015 Dylan. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var venueLogo: UIImageView!
    
    @IBOutlet weak var entryCostLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    
    var thai = true
    var english = false
    
    var eventDeets = ""
    var eventDeetsThai = ""
    var eventImageURL = ""
    var eventTitle = ""
    var logo = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.eventImage.image = UIImage(named:eventImageURL)
        self.eventDescription.text = self.eventDeetsThai
        self.venueLogo.image = UIImage(named:self.logo)
        self.thaiButton.alpha = 0.8
        self.thaiButton.enabled = false
        self.englishButton.alpha = 0.8
        self.englishButton.enabled = true
        
        
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
        thai = true
        english = false
        self.eventDescription.text = self.eventDeetsThai

    }
    @IBAction func englishButtonPress(sender: AnyObject) {
        thaiButton.enabled = true
        englishButton.enabled = false
        thai = false
        english = true
        self.eventDescription.text = self.eventDeets
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