//
//  GetImage.swift
//  KKEvents
//
//  Created by Southard Dylan on 5/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation
import UIKit
struct GetImage {
    func getImageFromDocuments (imageName: String) -> UIImage {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let getImagePath = paths.stringByAppendingPathComponent(imageName)
        var image:UIImage = UIImage()
        if NSFileManager().fileExistsAtPath(getImagePath) {
            
            image = UIImage(contentsOfFile: getImagePath)!
        } else {
            image = UIImage(named: "noImage.png")!
        }
        
            return image
    
    
    }
}