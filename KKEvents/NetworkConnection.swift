//
//  NetworkConnection.swift
//  KKEvents
//
//  Created by Southard Dylan on 4/1/16.
//  Copyright © 2016 Dylan. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
    SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }) else {
    return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
    return false
    }
    
    let isReachable = flags.contains(.Reachable)
    let needsConnection = flags.contains(.ConnectionRequired)
    return (isReachable && !needsConnection)
    }
    
}
