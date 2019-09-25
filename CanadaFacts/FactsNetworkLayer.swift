//
//  FactsNetworkLayer.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class FactsNetworkLayer {
    
    func getHomeData(completionHandler: @escaping (Result<Data,Error>) -> Void) {
        let dictionary = Bundle.main.infoDictionary!
        guard let url = URL(string: dictionary["WebserviceURL"] as! String) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            guard let responseData = data else { return }
            completionHandler(.success(responseData))
        }
        task.resume()
    }
}
