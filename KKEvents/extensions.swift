//
//  extensions.swift
//  KKNightlife
//
//  Created by Dylan Southard on 1/7/17.
//  Copyright © 2017 Dylan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Date
{
    func isToday()-> Bool {
        let todaysDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let adjustedEventDate = calendar.date(byAdding: .hour, value: -3, to: self)
        let components1 = calendar.dateComponents([.year, .month, .day], from: todaysDate)
        let components2 = calendar.dateComponents([.year, .month, .day], from: adjustedEventDate!)
        if components1.day == components2.day && components1.month == components2.month && components1.year == components2.year {
            return true
        } else {
            return false
        }
    }
    
    func isThisWeekend()-> Bool {
        let todaysDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        if self.isAWeekend() {
            var adjustedDate:Date!
            if todaysDate.isAWeekend() {
                adjustedDate = calendar.date(byAdding: .day, value: -4, to: self)
            } else {
                adjustedDate = calendar.date(byAdding: .day, value: -7, to: self)
            }
            if todaysDate > adjustedDate {
                return true
            }
        }
        return false
    }
    
    func isAWeekend()-> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let adjustedDate = calendar.date(byAdding: .hour, value: -3, to: self)
        let components = calendar.dateComponents([.weekday], from: adjustedDate!)
        if components.weekday! == 1 || components.weekday! >= 6 {
            return true
        }
        return false
    }
    
    func string(_ language:String, dateFormat:[String:String])-> String {
        let identifier = ["Eng":"en_US_POSIX", "Thai":"th_TH"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat[language]!
        dateFormatter.locale = NSLocale(localeIdentifier: identifier[language]!) as Locale!
        return dateFormatter.string(from: self)
    }
    
    func daysUntil(_ date:Date) -> Int {
        let calendar = NSCalendar(identifier: .gregorian)!
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        
        let components = calendar.components([.day], from: date1, to: date2)
        return components.day!
    }
}
extension NSManagedObject {
    func stringValue(_ forKey:String)-> String {
        if let temp = self.value(forKey: forKey) as? String {
            return temp
        } else {
            print("error fetching value: " + forKey)
            return "no Value"
        }
    }
    
    func dateValue(_ forKey:String)-> Date {
        if let temp = self.value(forKey: forKey) as? Date {
            return temp
        } else {
            print("error fetching value: " + forKey)
            return Date()
        }
    }
    
    func doubleValue(_ forKey:String)-> Double {
        if let temp = self.value(forKey: forKey) as? Double {
            return temp
        } else {
            print("error fetching value: " + forKey)
            return 0.0
        }
    }
}

extension String  {
    func truncateTail (_ maxCharacters:Int)->String {
        var stringy = self
        let difference = stringy.characters.count - maxCharacters
        
        if difference > 0 {
            for index in 0...difference {
                stringy.remove(at: stringy.characters.index(before: stringy.endIndex))
            }
            let
            stringy = stringy+"…"
            return stringy
        } else {
            return self
        }
    }
    
    func UIColorFromRGB(alpha: Float = 1.0) -> UIColor {
        let scanner = Scanner(string:self)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
