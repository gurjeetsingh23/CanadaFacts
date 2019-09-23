//
//  Utility.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//


import UIKit
//Here all the common functions that can be reused in the application are defined
// for showing alert wherever required in application
func showAlert(title: String, message: String, buttons: [String] = ["OK"] , parent:UIViewController?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    for (index, button) in buttons.enumerated() {
        alert.addAction(UIAlertAction(title: button, style: index != (buttons.count - 1) ? .default : .cancel))
    }
    parent?.present(alert, animated: true, completion: nil)
}

