//
//  RowsModel.swift
//  CanadaFacts
//
//  Created by Julka, Gurjeet on 23/9/19.
//  Copyright © 2019 Gurjeet Singh Julka. All rights reserved.
//

import Foundation
//Model class for API response
struct Rows: Codable {
    
    let title: String?
    let description: String?
    let imageHref: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageHref
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        imageHref = try values.decodeIfPresent(String.self, forKey: .imageHref)
    }
}
