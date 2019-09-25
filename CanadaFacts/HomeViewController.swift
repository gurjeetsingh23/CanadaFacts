//
//  ViewController.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var factsCollectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    var dataLayer = FactsDataLayer()
    var computeArray = [UIImage?](repeating: nil, count:1000)
    let overlayView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let messageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        showOverlay()
        isConnectedToNetwork() ? fetchHomeData() : noNetworkAvailable()
    }
    
    func noNetworkAvailable() {
        hideOverlayView()
        showAlert(title: "Network", message: "No Network Available", parent: self)
    }
    
    func setUpScreen() {
        self.factsCollectionView!.alwaysBounceVertical = true
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.addTarget(self, action: #selector(refreshScreen), for: .valueChanged)
        self.factsCollectionView.addSubview(refreshControl)
    }
    
    func fetchHomeData() {
        self.dataLayer.fetchHomeData {[weak self] (success, error) in
            self?.hideOverlayView()
            self?.refreshControl.endRefreshing()
            switch success {
            case true: do {
                self?.navigationBarTitleSetup()
                self?.factsCollectionView.reloadData()
                }
            case false : do {
                if let error = error {
                    showAlert(title: "Error", message: error.localizedDescription, parent: self)
                }
                }
                
            }
        }
    }
    
    func navigationBarTitleSetup() {
        guard let title = self.dataLayer.baseModel.title else { return }
        self.navigationController?.navigationBar.topItem?.title = title
    }
    
    @objc func refreshScreen() {
        if isConnectedToNetwork() {
            fetchHomeData()
        }
    }
    
    func stopRefreshing() {
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.factsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func showOverlay(message : String = "Loading Data, please wait") {
        
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
    
    func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if dataLayer.baseModel != nil {
            guard let count = dataLayer.baseModel.rows?.count else { return 0}
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = factsCollectionView.dequeueReusableCell(withReuseIdentifier: "FactsCollectionViewCell", for: indexPath) as! FactsCollectionViewCell
        cell.titleLabel.text =  self.dataLayer.returnHeadingLabel(indexpath: indexPath.row)
        cell.imageView.image = UIImage(named: "placeholder")
        computeArray[indexPath.row] = nil
        if let imageURL = self.dataLayer.returnImage(indexpath: indexPath.row) {
            cell.imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder")) { (image, _, _, _) in
                if  let image = image {
                    self.computeArray[indexPath.row] = image
                    cell.imageView.image = image
                    self.factsCollectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if computeArray.count > 0, indexPath.row < computeArray.count, let image = computeArray[indexPath.row] {
            return CGSize(width: min(image.size.width, collectionView.frame.size.width), height: image.size.height)
        }
        let width = self.factsCollectionView.frame.size.width
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        controller.descriptionText = self.dataLayer.returnDescriptionLabel(indexpath: indexPath.row)
        controller.image = computeArray[indexPath.row]
        controller.headingTitle = self.dataLayer.returnHeadingLabel(indexpath: indexPath.row)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
