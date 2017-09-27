//
//  Prefs.swift
//  KKNightlife
//
//  Created by Dylan Southard on 1/7/17.
//  Copyright © 2017 Dylan. All rights reserved.
//

import UIKit

class Prefs: NSObject {

    var thaiOn = true
    var language = "Thai"
    
    override init() {
        super.init()
        self.refresh()
    }
    
    func refresh() {
        if let temp = UserDefaults.standard.object(forKey: "thaiOn") as? Bool {
            self.thaiOn = temp
        }
        if thaiOn == true {
            self.language = "Thai"
        } else {
            self.language = "Eng"
        }
    }
    
    func set() {
        UserDefaults.standard.set(self.thaiOn, forKey: "thaiOn")
        if thaiOn == true {
            self.language = "Thai"
        } else {
            self.language = "Eng"
        }
    }
}
