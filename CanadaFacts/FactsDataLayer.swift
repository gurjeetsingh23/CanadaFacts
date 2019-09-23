//
//  FactsDataLayer.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import Foundation

class FactsDataLayer {
    var initialBaseModel: BaseModel!
    var baseModel: BaseModel!
    var network = FactsNetworkLayer()
    
    //service call for fetching the data
    func fetchHomeData( completion :@escaping (_ success: Bool, _ error: Error?) -> Void) {
        self.network.getHomeData { (result: ResultType) in
            switch result {
            case .success(let data) :do {
                if let model = data as? BaseModel {
                    self.baseModel = model
                    var index = 0
                    guard let baseMod = self.baseModel.rows else {return}
                    for  row in baseMod {
                        if row.title == nil && row.description == nil && row.imageHref == nil {
                            self.baseModel.rows?.remove(at: index)
                        }
                        index += 1
                    }
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    completion(false, nil)
                }
                }
            case .error(let error) :do {
                completion(false, error as Error)
                }
            }
            
        }
    }
    
    //returing the heading label to view controller
    func returnHeadingLabel(indexpath: Int) -> String {
        guard let headingLabel = self.baseModel.rows?[indexpath].title else { return ""}
        return headingLabel
    }
    
    //returing the description label to view controller
    func returnDescriptionLabel(indexpath: Int) -> String {
        guard let descriptionLabel = self.baseModel.rows?[indexpath].description else { return ""}
        return descriptionLabel
    }
    
    //returing the imageUrl String to view controller
    func returnImage(indexpath: Int) -> String {
        guard let imageUrl = self.baseModel.rows?[indexpath].imageHref else { return ""}
        return imageUrl
    }
    
}
