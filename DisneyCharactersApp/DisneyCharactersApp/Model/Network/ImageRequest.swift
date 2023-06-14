//
//  ImageRequest.swift
//  DisneyCharactersApp
//
//  Created by Kseniya Kuidina on 10/06/2023.
//

import UIKit

struct ImageRequest: DataRequest {

    let url: String
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NSError(type: .ImageFromDataFailure)
        }
        
        return image
    }
}
