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
    var imagesArray = [UIImage?](repeating: nil, count:1000)
    let loading = LoadingOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        loading.showOverlay(view: self.view)
        isConnectedToNetwork() ? fetchHomeData() : noNetworkAvailable()
    }
    
    func noNetworkAvailable() {
        loading.hideOverlayView()
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
            self?.loading.hideOverlayView()
            self?.refreshControl.endRefreshing()
            switch success {
            case true:
                self?.navigationBarTitleSetup()
                self?.factsCollectionView.dataSource = self
                self?.factsCollectionView.delegate = self
                self?.factsCollectionView.reloadData()
            case false:
                if let error = error {
                    showAlert(title: "Error", message: error.localizedDescription, parent: self)
                } else {
                     showAlert(title: "Error", message: "Some Error Occured", parent: self)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.factsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            guard let count = dataLayer.baseModel.rows?.count else { return 0 }
            return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = factsCollectionView.dequeueReusableCell(withReuseIdentifier: "FactsCollectionViewCell", for: indexPath) as! FactsCollectionViewCell
        cell.titleLabel.text = dataLayer.returnHeadingLabel(indexpath: indexPath.row)
        cell.imageView.image = UIImage(named: "placeholder")
        if let imageURL = self.dataLayer.returnImage(indexpath: indexPath.row) {
            cell.imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder")) { (image, _, _, _) in
                if  let image = image {
                    self.imagesArray[indexPath.row] = image
                    cell.imageView.image = image
                    self.factsCollectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let image = imagesArray[indexPath.row] {
            return CGSize(width: min(image.size.width, collectionView.frame.size.width), height: image.size.height)
        }
        let width = self.factsCollectionView.frame.size.width
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        controller.descriptionText = self.dataLayer.returnDescriptionLabel(indexpath: indexPath.row)
        controller.image = imagesArray[indexPath.row]
        controller.headingTitle = self.dataLayer.returnHeadingLabel(indexpath: indexPath.row)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
