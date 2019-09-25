//
//  Utility.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//


import UIKit
import SystemConfiguration
//Here all the common functions that can be reused in the application are defined

// for showing alert wherever required in application
func showAlert(title: String, message: String, buttons: [String] = ["OK"] , parent:UIViewController?) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    for (index, button) in buttons.enumerated() {
        alert.addAction(UIAlertAction(title: button, style: index != (buttons.count - 1) ? .default : .cancel))
    }
    parent?.present(alert, animated: true, completion: nil)
}
//for checking the network connectivity
func isConnectedToNetwork() -> Bool {
    var address = sockaddr_in()
    address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    address.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &address, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    if flags.isEmpty {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}

