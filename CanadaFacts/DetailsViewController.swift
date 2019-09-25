//
//  DetailsViewController.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    var image : UIImage?
    var descriptionText : String?
    var headingTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = image {
            detailsImage.image = image
        }
        if let desc = descriptionText {
            detailsLabel.text = desc
        }
    }
    
}
