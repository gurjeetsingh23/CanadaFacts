//
//  FactsDataLayer.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import Foundation

class FactsDataLayer {
    var baseModel: BaseModel!
    var network = FactsNetworkLayer()
    
    //service call for fetching the data
    func fetchHomeData( completion :@escaping (_ success: Bool, _ error: Error?) -> Void) {
        self.network.getHomeData { result in
            switch result {
            case .success(let data) :
                let encodingString = String(data: data, encoding: .isoLatin1)
                let dataUsingUTF8: Data? = encodingString?.data(using: .utf8)
                var responseDictionary: [AnyHashable: Any]?
                if let dataUsingUTF8 = dataUsingUTF8 {
                    do {
                        responseDictionary = try JSONSerialization.jsonObject(with: dataUsingUTF8, options: .mutableContainers) as? [AnyHashable: Any]
                    } catch {
                        completion(false, nil)
                    }
                }
                do {
                    guard let respDict = responseDictionary else { return }
                    let jsonData = try JSONSerialization.data(withJSONObject: respDict, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    self.baseModel =  try decoder.decode(BaseModel.self, from: jsonData as Data)
                    guard let baseModel =  self.baseModel.rows else { return }
                    var index = 0
                    for row in baseModel {
                        if row.title == nil && row.description == nil && row.imageHref == nil {
                            self.baseModel.rows?.remove(at: index)
                        }
                        index += 1
                    }
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } catch {
                    completion(false, nil)
                }
            case .failure(let error):
                completion(false, error as Error)
            }
        }
    }
    
    //returing the heading label to view controller
    func returnHeadingLabel(indexpath: Int) -> String? {
        guard let headingLabel = self.baseModel.rows?[indexpath].title else { return nil }
        return headingLabel
    }
    
    //returing the description label to view controller
    func returnDescriptionLabel(indexpath: Int) -> String? {
        guard let descriptionLabel = self.baseModel.rows?[indexpath].description else { return nil }
        return descriptionLabel
    }
    
    //returing the imageUrl String to view controller
    func returnImage(indexpath: Int) -> String? {
        guard let imageUrl = self.baseModel.rows?[indexpath].imageHref else { return nil }
        return imageUrl
    }
}
