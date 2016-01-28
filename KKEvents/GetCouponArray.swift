//
//  GetCouponArray.swift
//  KKEvents
//
//  Created by Southard Dylan on 1/24/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import UIKit


   
class GetCoupon: NSObject {

    func GetCouponInfo (couponFile:NSDictionary, venueFile:NSDictionary)-> Coupon{
       
        let c:Coupon = Coupon()
        c.couponVenue = venueFile["venueName"] as! String
        c.couponLogo = venueFile["venueLogoImageUrl"] as! String
        c.couponPhoneNumber = venueFile["venuePhoneNumber"] as! String
        c.couponMap = venueFile["venueCoordinates"] as! [Double]
        
        c.couponTitle = couponFile["couponTitle"] as! String
        c.couponTitleThai = couponFile["couponTitleThai"] as! String
        c.couponDescription = couponFile["couponDescription"] as! String
        c.couponDescriptionThai = couponFile["couponDescriptionThai"] as! String
        c.couponImage = couponFile["couponImage"] as! String
        c.couponDate = couponFile["couponDate"] as! [Int]
        c.couponEndDate = couponFile["couponEndDate"] as! [Int]
        if let subThai = couponFile["couponSubtitleThai"] {
        c.couponSubtitleThai = subThai as! String
        }
        if let subEng = couponFile["couponSubtitle"] {
            c.couponSubtitle = subEng as! String
        }
        
        return c
    }
    
    func couponNotExpired (coupon:Coupon)-> Int{

        
        let date = NSDate()
        let cal = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        
        let expiryDay = coupon.couponEndDate[2] + 1
        let expiryDateNoTime = "\(coupon.couponEndDate[0])"+"-"+"\(coupon.couponEndDate[1])"+"-"+"\(expiryDay)"
       
        
        let expiryDateString = expiryDateNoTime + " " + "02:00:00"
        let expiryDate = NSDate(dateString: expiryDateString)
        
        let unit:NSCalendarUnit = NSCalendarUnit.Day
        
        let components = cal!.components(unit, fromDate: date, toDate: expiryDate, options: [])
        print("the number of days left is \(components.day)")
        
        
               
        return components.day
    }
}
