//
//  LoadingOverlay.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import UIKit

//This class is defined for adding the loading overlay when API call is in progress
public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var messageLabel = UILabel()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView, message : String = "Loading Data, please wait") {
        
        overlayView.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor.black .withAlphaComponent(0.5)
        overlayView.clipsToBounds = true
        activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x:overlayView.bounds.width / 2, y:overlayView.bounds.height / 2)
        messageLabel.frame = CGRect(x:0, y:0, width: 200, height: 40)
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.center = CGPoint(x:overlayView.bounds.width / 2, y:overlayView.bounds.height / 2 + activityIndicator.frame.size.height)
        overlayView.addSubview(activityIndicator)
        overlayView.addSubview(messageLabel)
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
