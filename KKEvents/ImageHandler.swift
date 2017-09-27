//
//  ImageHandler.swift
//  KKNightlife
//
//  Created by Dylan Southard on 1/7/17.
//  Copyright © 2017 Dylan. All rights reserved.
//

import UIKit
import CloudKit

class ImageHandler: NSObject {
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    func getImageData (_ imageName: String) -> UIImage {
        
        let getImagePath = self.paths.appendingPathComponent(imageName)
        var image:UIImage = UIImage()
        if imageName != "" {
            if FileManager().fileExists(atPath: getImagePath) {
                
                image = UIImage(contentsOfFile: getImagePath)!
            }else {
                image = UIImage(named: "noImage.png")!
            }
        }else {
            image = UIImage(named: "noImage.png")!
        }
        
        return image
    }
    
    func removeImageData (_ imageName:String) {
        
        let getImagePath = self.paths.appendingPathComponent(imageName)
        if self.imageExists(imageName) || imageName != "noImage.png" || imageName != "KKNightlifeLogo.png"{
            //print("The file already exists at path")
            do {
                try FileManager.default.removeItem(atPath: getImagePath)
                print("image file Removed")
            }catch {
                // print("file not removed")
            }
        }
        
    }
    
    func imageExists (_ imageName:String)-> Bool {
        let imagePath = self.paths.appendingPathComponent(imageName)
        if FileManager().fileExists(atPath: imagePath) {
            return true
        }
        return false
    }
    
    func saveImage (_ imageAsset: CKAsset, imageName: String) {
        
        let imageURL = imageAsset.fileURL
        
        // create your document folder url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        // your destination file url
        let destinationUrl = documentsUrl.appendingPathComponent(imageName)
        
            if let imageFileFromUrl = try? Data(contentsOf: imageURL){
                // after downloading your data you need to save it to your destination url
                if (try? imageFileFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                    print("file \(imageName) which was saved" )
                    
                    if FileManager().fileExists(atPath: destinationUrl.path) {
                        print("\(imageName) now exists")
                    }
                } else {
                    print("error saving file " + imageName)
                    
                }
                
            }
    }

}
