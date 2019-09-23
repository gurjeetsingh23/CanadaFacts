//
//  BaseModel.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet  on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import Foundation

struct BaseModel: Codable {
    let title: String?
    var rows: [Rows]?
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case rows
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        rows = try values.decodeIfPresent([Rows].self, forKey: .rows)
    }
}

