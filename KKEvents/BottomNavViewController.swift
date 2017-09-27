//
//  bottomNavViewController.swift
//  KKNightlife
//
//  Created by Dylan Southard on 2017/09/26.
//  Copyright © 2017 Dylan. All rights reserved.
//

import UIKit

class BottomNavViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var promotionsButton: UIButton!
    @IBOutlet weak var venuesButton: UIButton!
    
    var currentView = "events"
    var views = ["events", "promotions", "venues"]
    var buttons = [UIButton]()
    
//***** Objects *****
    let prefs = Prefs()
    var coreData = CoreData()
    let imageHandler = ImageHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttons = [self.eventsButton, self.promotionsButton, self.venuesButton]
            self.eventsButton.isEnabled = false
        

        _ = self.loadContainer(0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func eventsPressed(_ sender: Any) {
        self.switchView(0)
    }
    @IBAction func promotionsPressed(_ sender: Any) {
        self.switchView(1)
    }
    @IBAction func venuesPressed(_ sender: Any) {
        self.switchView(2)
    }
    
    func switchView (_ buttonNumber: Int) {
        let fromView = self.currentView
        self.currentView = views[buttonNumber]
        let fromButtonNumber = self.views.index(of: fromView)
        
        
        
        
        let controller = self.loadContainer(-view.frame.width)
        
        UIView.animate(withDuration:0.3, animations:{
            self.buttons[buttonNumber].transform = self.buttons[buttonNumber].transform.rotated(by: (180.0 * CGFloat(Double.pi)) / 180.0)
            self.buttons[fromButtonNumber!].transform = self.buttons[fromButtonNumber!].transform.rotated(by: (180.0 * CGFloat(Double.pi)) / 180.0)
            controller.view.center.x += self.view.frame.width
            
        }, completion: {(finished: Bool) in
            if self.container.subviews.count > 1 {
                let currentSubview = self.container.subviews[0]
                currentSubview.removeFromSuperview()
                self.buttons[buttonNumber].isEnabled = false
                self.buttons[fromButtonNumber!].isEnabled = true
                print("\(self.container.subviews.count) subviews")
            }
        })
        

    }
    
    func loadContainer (_ xValue: CGFloat)-> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: self.currentView) as! MainViewController
        controller.navDelegate = self
        self.addChildViewController(controller)
        controller.view.frame = CGRect(x: xValue, y: 0, width: self.container.frame.size.width, height:self.container.frame.size.height)
        self.container.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        return controller
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
