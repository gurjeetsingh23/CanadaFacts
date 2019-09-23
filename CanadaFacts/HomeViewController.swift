//
//  ViewController.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var factsCollectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    var dataLayer = FactsDataLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        LoadingOverlay.shared.showOverlay(view: self.view)
        fetchHomeData()
    }
    
    func setUpScreen() {
        self.factsCollectionView!.alwaysBounceVertical = true
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.addTarget(self, action: #selector(refreshScreen), for: .valueChanged)
        self.factsCollectionView!.addSubview(refreshControl)
    }
    
    func fetchHomeData() {
        self.dataLayer.fetchHomeData {[weak self] (success, error) in
            LoadingOverlay.shared.hideOverlayView()
            switch success {
            case true: do {
                self?.navigationBarTitleSetup()
                print(self?.dataLayer.baseModel)
                }
            case false : do {
                if let error = error {
                    // self.showAlert(title: HomeConstants.errorAlertTitle, desc: error.localizedDescription)
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
        stopRefreshing()
    }
    
    func stopRefreshing() {
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.factsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.factsCollectionView.dequeueReusableCell(withReuseIdentifier: "FactsCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.factsCollectionView.frame.size.width
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
