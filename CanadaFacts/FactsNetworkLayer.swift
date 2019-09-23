//
//  FactsNetworkLayer.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import Foundation

enum ResultType: Any {
    case success(data: Any?)
    case error(error:Error)
}

class FactsNetworkLayer {
    func getHomeData(withCompletionHandler completionHandler: @escaping (_ result: ResultType) -> Void) {
        let dictionary = Bundle.main.infoDictionary!
        guard let url = URL(string: dictionary["WebserviceURL"] as! String) else { return }
       let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            // encoding the data received to UTF8
            let encodingString = String(data: data!, encoding: .isoLatin1)
            let dataUsingTF8: Data? = encodingString?.data(using: .utf8)
            var responseDictionary: [AnyHashable: Any]?
            if let dataUsingTF8 = dataUsingTF8 {
                do {
                    responseDictionary = try JSONSerialization.jsonObject(with: dataUsingTF8, options: .mutableContainers) as? [AnyHashable: Any]
                } catch {
                    print("Error occured while Json serialization")
                }
            }
            do {
                guard let respDict = responseDictionary else {return}
                let jsonData = try JSONSerialization.data(withJSONObject: respDict, options: .prettyPrinted)
                let dataObj: BaseModel
                let decoder = JSONDecoder()
                
                //adding the decoded data to Model Class
                dataObj =  try decoder.decode(BaseModel.self, from: jsonData as Data)
                completionHandler(ResultType.success(data: dataObj))
                
            } catch {
                completionHandler(ResultType.error(error: error))
                
            }
            
            }
        task.resume()
        
    }
}
